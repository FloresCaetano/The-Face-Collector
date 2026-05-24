class_name AnimationManager
extends Node3D

@onready var player_real_camera : PlayerRealCamera = PATHS.player_real_camera
@onready var player : Player = PATHS.player
@export var fp_camera : PhantomCamera3D
@export var animation_player : AnimationPlayer
@export var main_node : Node3D
@export var last_player_position : Vector3
@export var last_player_rotation : Vector3

signal animation_started
signal animation_finished

func start_animation(anim_name : String):
	player_real_camera.change_state(player_real_camera.State.BLOQUED)
	player.desactivate()
	fp_camera.priority = 20
	
	await fp_camera.tween_completed
	animation_started.emit()
	if main_node: main_node.visible = true
	animation_player.play(anim_name)
	
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim):
	if main_node: main_node.visible = false
	player.global_transform.origin = calculate_new_player_position()
	var rot := calculate_new_player_rotation()
	
	player.rotation.y = rot.y + PI
	player.pivot.rotation.x = rot.x 
	player.pivot.rotation.y = 0.0
	player.pivot.rotation.z = 0.0
	fp_camera.priority = 0
	
	await player_real_camera.active_camera.tween_completed
	player_real_camera.change_state(player_real_camera.State.IDLE)
	player.activate()
	animation_finished.emit()

func calculate_new_player_position() -> Vector3:
	var player_relative_to_camera : Vector3 = player.global_transform.origin - PATHS.main_pcamera.global_transform.origin
	var new_player_position : Vector3 = fp_camera.global_transform.origin + player_relative_to_camera
	return new_player_position

func calculate_new_player_rotation() -> Vector3:
	var fp_euler := fp_camera.global_transform.basis.get_euler()
	return Vector3(fp_euler.x, fp_euler.y, 0.0)
	
	
