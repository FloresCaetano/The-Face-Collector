class_name CassetteTapePlayerInterface
extends Node3D

@export var phantom_camera_3d: PhantomCamera3D
@export var tape_linear_container: TapeLinearContainer
@onready var p_rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var a_state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _ready() -> void:
	a_state_machine.state_started.connect(_on_state_started)

func enter_cassette_tape_view():
	phantom_camera_3d.rotation = Vector3.ZERO
	await p_rcam.change_state(p_rcam.State.BLOQUED)
	phantom_camera_3d.priority = 20
	await phantom_camera_3d.tween_completed
	visible = true
	
	tape_linear_container.reload_tapes()
	animation_tree.active = true
	a_state_machine.travel("show_box")
	await a_state_machine.state_finished
	
	p_rcam.change_state(p_rcam.State.FOLLOW_CURSOR)

func leave_cassette_tape_view():
	await p_rcam.change_state(p_rcam.State.BLOQUED)
	phantom_camera_3d.priority = 0
	await p_rcam.active_camera.tween_completed
	
	a_state_machine.travel("hide_box")
	visible = false
	animation_tree.active = false
	tape_linear_container.clear_tapes()
	p_rcam.change_state(p_rcam.State.IDLE)

func anim_tape_selected():
	animation_tree.active = true
	await p_rcam.change_state(p_rcam.State.BLOQUED)
	a_state_machine.travel("insert_cassette")

signal insert_cassette_finished
func _on_state_started(state : StringName) -> void:
	if state == "End":
		phantom_camera_3d.priority = 0
		await p_rcam.active_camera.tween_completed
		await get_tree().create_timer(0.5).timeout
		visible = false
		animation_tree.active = false
		insert_cassette_finished.emit()
