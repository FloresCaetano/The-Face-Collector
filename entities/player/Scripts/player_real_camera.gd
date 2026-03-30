class_name PlayerRealCamera
extends Camera3D

@export var shape_cast: ShapeCast3D

func _physics_process(_delta):
	var best_target : Interactable = _get_most_central_target()
	if best_target:
		best_target.interact()

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
