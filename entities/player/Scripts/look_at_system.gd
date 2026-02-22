class_name LookAtHandler
extends Marker3D

@export var duration : float
@export var unlock_player : bool = false
@export var externally_activated : bool = false

@export var permanent : bool = false

@onready var pos : Vector3 = self.global_position
@onready var camera = PATHS.camera

signal look_at_ends

func force_look_at_real_cam():
	PATHS.player.desactivate()
	var direccion = pos - PATHS.player.global_position
	var angulo_y = atan2(direccion.x, direccion.z)
	PATHS.player.rotation.y = angulo_y
	var distancia_horizontal = Vector2(direccion.x, direccion.z).length()
	var angulo_x = atan2(-direccion.y, distancia_horizontal)
	PATHS.camera.get_parent().rotation.x = angulo_x

func force_look_at_fake_cam():
	PATHS.player.desactivate()
	var fake_camera : Camera3D = PATHS.camera.duplicate()
	PATHS.player.add_sibling(fake_camera)
	fake_camera.global_transform = camera.global_transform
	fake_camera.fov = camera.fov
	fake_camera.current = true
	force_look_at_real_cam()
	
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(fake_camera, "global_transform", camera.global_transform, duration)
	tween.tween_callback(func():
		fake_camera.queue_free() 
		look_at_ends.emit()
		if unlock_player: PATHS.player.activate()
		)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player and not externally_activated:
		if not permanent:
			$Area3D.queue_free()
		force_look_at_fake_cam()
