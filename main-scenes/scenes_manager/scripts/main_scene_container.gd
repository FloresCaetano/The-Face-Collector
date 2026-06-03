class_name SceneManager
extends Control


@export var main_scene_sub_viewport: SubViewportContainer
@export var sub_viewport: SubViewport
@export var main_scene: Node3D
var new_flashback_scene

@export var hud: CanvasLayer
@export var viewport_overlay_rect: ColorRect
@export var flash_back_voice_icon: TextureRect
@export var flashback_voice: MarginContainer

signal flashback_transition_ends
signal flashback_ends(flashbackuid : String)

var old_player : Player
var old_camera : PlayerRealCamera

var last_flashback_uid : String = ""

func instantiate_flashsback(scene_path : String):
	old_player = PATHS.player
	old_camera = PATHS.player_real_camera
	
	var tape_transition_sv: SubViewport = load("uid://bhp54cwawcdvo").instantiate()
	tape_transition_sv.size = get_viewport_rect().size
	tape_transition_sv.disable_3d = true
	main_scene_sub_viewport.add_child(tape_transition_sv)
	await get_tree().process_frame
	tape_transition_sv.disable_3d = false
	
	ResourceLoader.load_threaded_request(scene_path)
	
	var tween_fade = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_fade.tween_property(viewport_overlay_rect, "color", Color.BLACK, 0.8)
	PATHS.audio_controller.fade_bus_volume("Master", -80.0, 0.8)
	await tween_fade.finished
	PATHS.audio_controller.stop_all_volumes_in_scene(main_scene)
	
	tape_transition_sv.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var transition_camera_texture : Texture = ImageTexture.create_from_image(tape_transition_sv.get_texture().get_image())
	main_scene.process_mode = Node.PROCESS_MODE_DISABLED
	while ResourceLoader.load_threaded_get_status(scene_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	
	await get_tree().create_timer(4.0).timeout
	
	var new_scene_res = ResourceLoader.load_threaded_get(scene_path)
	new_flashback_scene = new_scene_res.instantiate()
	
	desactivate_player_systems()
	
	sub_viewport.remove_child(main_scene)
	sub_viewport.add_child(new_flashback_scene)
	
	old_camera.current = false
	
	var vp_texture_rect : TextureRect = TextureRect.new()
	vp_texture_rect.texture = transition_camera_texture
	vp_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	vp_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	vp_texture_rect.size = get_viewport().get_visible_rect().size
	hud.add_child(vp_texture_rect)
	
	tape_transition_sv.queue_free()
	
	var tween_move = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_move.tween_property(vp_texture_rect, "size", flash_back_voice_icon.size, 1.0)
	tween_move.tween_property(vp_texture_rect, "global_position", flash_back_voice_icon.global_position, 1.0)
	await tween_move.finished
	
	flash_back_voice_icon.texture = transition_camera_texture
	vp_texture_rect.queue_free()
	
	var tween_reveal = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_reveal.tween_property(viewport_overlay_rect, "color", Color.TRANSPARENT, 0.8)
	PATHS.audio_controller.fade_bus_volume("Master", 0.0, 0.8)
	
	await tween_reveal.finished
	flashback_transition_ends.emit()
	last_flashback_uid = scene_path

func end_flashback():
	PATHS.fade_controller.fade_in(5.0)
	await PATHS.fade_controller.fade_in_finished
	sub_viewport.remove_child(new_flashback_scene)
	sub_viewport.add_child(main_scene)
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(flash_back_voice_icon, "modulate:a", 0.0, 5.0) #TODO Fix this modulate
	tween.tween_callback(func(): flash_back_voice_icon.texture = null ; flash_back_voice_icon.modulate.a = 1.0)
	
	new_flashback_scene.queue_free()
	
	main_scene.process_mode = Node.PROCESS_MODE_INHERIT
	reactivate_player_systems()
	old_player.get_node("Pivot/PMainCamera").priority = 10
	
	await PATHS.audio_controller.fade_bus_volume("Master", -80.0, 5.0)
	PATHS.audio_controller.restore_all_volumes_in_scene(main_scene)
	
	PATHS.fade_controller.fade_out(3.0)
	await PATHS.audio_controller.fade_bus_volume("Master", 0.0, 5.0)
	
	old_player = null
	flashback_ends.emit(last_flashback_uid)

var old_player_groups = {}
func desactivate_player_systems() -> void:
	old_player.get_node("Pivot/PMainCamera").priority = 0
	old_player_groups.clear()
	var nodes = [old_player] + old_player.find_children("*", "", true, false)
	for node in nodes:
		var non_internal_groups = node.get_groups().filter(
			func(g): return not str(g).begins_with("_")
		)
		old_player_groups[node] = non_internal_groups
		for group in non_internal_groups:
			node.remove_from_group(group)

func reactivate_player_systems() -> void:
	old_player.get_node("Pivot/PMainCamera").priority = 10
	for node in old_player_groups.keys():
		if is_instance_valid(node):
			for group in old_player_groups[node]:
				node.add_to_group(group)
	old_player_groups.clear()
