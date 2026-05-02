class_name SceneManager
extends Control


@export var main_scene_sub_viewport: SubViewportContainer
@export var sub_viewport: SubViewport
@export var main_scene: Node3D

@export var hud: CanvasLayer
@export var viewport_overlay_rect: ColorRect
@export var flash_back_voice_icon: TextureRect
@export var flashback_voice: MarginContainer

func instantiate_flashsback(scene_path : String):
	var tape_transition_sv: SubViewport = load("uid://bhp54cwawcdvo").instantiate()
	main_scene_sub_viewport.add_child(tape_transition_sv)
	
	ResourceLoader.load_threaded_request(scene_path)
	
	var tween_fade = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_fade.tween_property(viewport_overlay_rect, "color", Color.BLACK, 0.8)
	PATHS.audio_controller.fade_bus_volume("Master", -80.0, 0.8)
	await tween_fade.finished
	
	tape_transition_sv.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var transition_camera_texture : Texture = ImageTexture.create_from_image(tape_transition_sv.get_texture().get_image())
	main_scene.set_process(false)
	while ResourceLoader.load_threaded_get_status(scene_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	
	await get_tree().create_timer(4.0).timeout
	
	var new_scene_res = ResourceLoader.load_threaded_get(scene_path)
	var new_flashback_scene = new_scene_res.instantiate()
	
	sub_viewport.remove_child(main_scene)
	sub_viewport.add_child(new_flashback_scene)
	
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
	
	
