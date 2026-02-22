extends Node3D

var mouse_delta = Vector2()
var min_look_angle : float = -75
var max_look_angle : float = 80
var cameraLock : bool = false
var zoom : int = 25 #THIS IS FOV VALUE (less = more zoom)
@onready var player = $".."
@onready var camera = $Camera3D

var mouse_input : Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if cameraLock:
		mouse_input = Vector2.ZERO
		return
		
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_input += event.relative

func _process(delta: float) -> void:
	if cameraLock:
		mouse_input = Vector2.ZERO
		return

	if mouse_input.length() > 0:
		var rotation_speed = GAMEMANAGER.look_sensitivity * delta * 60.0
		
		player.rotate_y(deg_to_rad(-mouse_input.x * rotation_speed))
		rotate_x(deg_to_rad(mouse_input.y * rotation_speed))
		rotation.x = clamp(rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
		mouse_input = Vector2.ZERO
