class_name PlayerRealCamera
extends Camera3D

@onready var player : Player = PATHS.player

@export var shape_cast: ShapeCast3D
@export var p_look_at_cam : PhantomCamera3D
@export var p_main_camera : PhantomCamera3D

var last_best_target : Interactable

func _physics_process(_delta):
	var best_target : Interactable = _get_most_central_target()
	
	if best_target != last_best_target:
		if last_best_target:
			last_best_target.mouse_exited()
		
	if best_target:
		best_target.interact()

	last_best_target = best_target

func _get_most_central_target() -> Object:
	if not shape_cast.is_colliding():
		return null

	var closest_obj = null
	var max_dot = -1.0
	var camera_forward = -global_transform.basis.z

	for i in range(shape_cast.get_collision_count()):
		
		var collider = shape_cast.get_collider(i)
		if collider is not Interactable:
			return
		
		var direction_to_obj = (collider.global_position - global_position).normalized()
		var dot_product = camera_forward.dot(direction_to_obj)

		if dot_product > max_dot:
			max_dot = dot_product
			closest_obj = collider

	return closest_obj as Interactable

func look_at_target(target: Node3D, duration : float, wait_time : float) -> void:
	p_look_at_cam.global_transform = p_look_at_cam.global_transform.looking_at(target.global_transform.origin)
	p_look_at_cam.tween_resource.duration = duration
	p_look_at_cam.priority = 20
	
	p_main_camera.set_noise(null)
	p_main_camera.teleport_position()
	player.desactivate()
	
	await get_tree().create_timer(wait_time).timeout
	p_look_at_cam.priority = 0
	
	await p_main_camera.tween_completed
	player.activate()
	p_main_camera.set_noise(load("uid://cy8qckhmvhur2"))
