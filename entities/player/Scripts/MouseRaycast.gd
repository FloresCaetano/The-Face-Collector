extends Camera3D

var last_best_target : Interactable

func _process(_delta: float) -> void:
	point_interact()

func point_interact():
	var raycast_result : Dictionary = throw_raycast(5.0)
	if not raycast_result.has("collider"):
		if last_best_target:
			last_best_target.mouse_exited()
			last_best_target = null
		return
	
	if not raycast_result.collider is Interactable:
		if last_best_target:
			last_best_target.mouse_exited()
			last_best_target = null
		return
	
	var collider = raycast_result.collider

	if collider != last_best_target and last_best_target:
		last_best_target.mouse_exited()
	last_best_target = collider
	collider.interact()

func throw_raycast(ray_distance : float, interaction_mask : int = 0b1) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	
	var origin : Vector3 = project_ray_origin(mouse_pos)
	var end : Vector3 = origin + project_ray_normal(mouse_pos) * ray_distance
	
	var query = PhysicsRayQueryParameters3D.create(origin, end, interaction_mask)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	result["end"] = end
	
	return result
