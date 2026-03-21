class_name Pivot
extends Node3D

var mouse_delta = Vector2()
var min_look_angle : float = -75
var max_look_angle : float = 80
var cameraLock : bool = false
var zoom : int = 25 #THIS IS FOV VALUE (less = more zoom)
@onready var player = $".."

var mouse_input : Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if cameraLock:
		return
		
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		var sensitivity = GAMEMANAGER.look_sensitivity
		
		player.rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		rotate_x(deg_to_rad(event.relative.y * sensitivity))
		
		rotation.x = clamp(rotation.x, deg_to_rad(min_look_angle), deg_to_rad(max_look_angle))
