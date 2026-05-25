extends Interactable

@onready var pcam: PhantomCamera3D = $open_food_can/Camera/PCam
@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var mouse_rotator_3d: MouseRotator3D = $MouseRotator3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var a_state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var can_mesh: MeshInstance3D = $open_food_can/supply_crate_1_1_002
@onready var cap_mesh: MeshInstance3D = $open_food_can/supply_crate_1_1_002/supply_crate_1_1_003

@onready var arms_mesh: Node3D = $open_food_can

var turn_count : int = 0
var turns_needed_to_end : float = 5

func mouse_interaction() -> void:
	if not inventory.has_item("food_can"):
		GAMEMANAGER.bark_dialogue("bark_alice_first_flashback", [1,1])
		return
	
	await player_rcam.change_state(player_rcam.State.BLOQUED)
	pcam.priority = 20
	await pcam.tween_completed
	player_rcam.change_state(player_rcam.State.FOLLOW_CURSOR)
	
	arms_mesh.visible = true
	a_state_machine.travel("Global_place_can")
	await animation_tree.animation_finished
	
	mouse_rotator_3d.is_active = true


func _on_mouse_rotator_3d_turn_completed() -> void:
	mouse_rotator_3d.is_active = false
	a_state_machine.travel("Global_turn_the_knob");
	turn_count += 1
	await animate_can()
	
	if turn_count == turns_needed_to_end:
		await take_can_animation()
		leave_interaction()
	
	if is_interacting:
		mouse_rotator_3d.is_active = true

func animate_can():
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(can_mesh, "rotation_degrees:y", 360 / turns_needed_to_end, 0.6).as_relative()
	await tween.finished

func take_can_animation():
	await player_rcam.change_state(player_rcam.State.BLOQUED)
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pcam, "rotation", Vector3.ZERO, 0.4)
	
	a_state_machine.travel("Global_take_can");
	while a_state_machine.get_current_node() != "End":
		await get_tree().process_frame
	arms_mesh.visible = false
	pcam.priority = 0
	await player_rcam.active_camera.tween_completed
	player_rcam.change_state(player_rcam.State.IDLE)
	
	inventory.remove_item_by_tag("food_can")
	inventory.add_item(load("uid://dibc2oux5fyei")) #opened_food_can
	turn_count = 0
	
	mouse_rotator_3d.is_active = false

func on_mouse_exited() -> void:
	pass
