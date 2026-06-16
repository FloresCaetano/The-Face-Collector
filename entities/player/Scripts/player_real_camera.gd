class_name PlayerRealCamera
extends Camera3D

@onready var player : Player = PATHS.player
@onready var phantom_camera_host: PhantomCameraHost = $PhantomCameraHost

@export var zoom_in_fov = 50
@onready var default_zoom_fov = self.fov
@export var p_main_camera: PhantomCamera3D
@export var p_look_at_cam: PhantomCamera3D
@export var pivot: Pivot

var last_best_target : Interactable
var can_interact : bool = true
var original_rotation := Vector3.ZERO

enum State { IDLE, BLOQUED, FOLLOW_CURSOR }
var actual_state : State = State.IDLE
var active_camera : PhantomCamera3D :
	get:
		return phantom_camera_host.get_active_pcam()

func change_state(new_state: State):
	match actual_state: #This code will execute when leaving a state
		State.FOLLOW_CURSOR:
			pass
			#p_main_camera.global_rotation = original_rotation
	
	match new_state: #This will execute when entering a state
		State.BLOQUED:
			pivot.set_camera_lock(true)
		State.IDLE:
			pivot.set_camera_lock(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		State.FOLLOW_CURSOR:
			pivot.set_camera_lock(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_base_rotation = active_camera.global_transform.basis.get_euler()
	
	actual_state = new_state
	await get_tree().physics_frame

func _process(_delta):
	match actual_state:
		State.IDLE:
			if can_interact: idle_interact(); zoom()
		State.FOLLOW_CURSOR:
			follow_cursor(_delta)
			if can_interact: point_interact()


var _base_rotation : Vector3
func follow_cursor(delta: float) -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	var mouse_normalized = (mouse_pos / viewport_size) * 2.0 - Vector2.ONE
	
	var max_yaw   = deg_to_rad(30.0)  # izquierda/derecha
	var max_pitch = deg_to_rad(15.0)  # arriba/abajo
	
	var target_yaw   = -mouse_normalized.x * max_yaw
	var target_pitch = -mouse_normalized.y * max_pitch
	
	var target_rot = _base_rotation + Vector3(target_pitch, target_yaw, 0)
	var final_transform = Transform3D(
		Basis.from_euler(target_rot),
		global_transform.origin
	)
	
	active_camera.global_transform = \
		active_camera.global_transform.interpolate_with(final_transform, 5.0 * delta)

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

func throw_raycast_with_offset(max_distance: float, collision_mask: int, local_offset: Vector3) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var ray_origin = global_position + (global_transform.basis.x * local_offset.x) + (global_transform.basis.y * local_offset.y)
	var camera_forward = -global_transform.basis.z
	
	var ray_target = ray_origin + (camera_forward * max_distance)
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target, collision_mask)
	var result = space_state.intersect_ray(query)
	
	return result

signal target_spotted       
signal sequence_finished   
func look_at_target(target: Node3D, duration : float, wait_time : float, return_to_original := true) -> void:
	p_look_at_cam.reparent(player.get_parent())
	p_look_at_cam.global_transform = p_main_camera.global_transform
	player.desactivate()
	await change_state(State.BLOQUED)
	
	p_look_at_cam.look_at(target.global_position)
	p_look_at_cam.tween_resource.duration = duration
	p_look_at_cam.priority = 20
	
	await p_look_at_cam.tween_completed
	
	target_spotted.emit()
	
	await get_tree().create_timer(wait_time).timeout
	
	if not return_to_original:
		var x_delta = p_main_camera.global_rotation.x - p_look_at_cam.global_rotation.x
		var y_delta = p_main_camera.global_rotation.y - p_look_at_cam.global_rotation.y
		pivot.rotate_x(x_delta)
		player.rotate_y(-y_delta)
		p_look_at_cam.priority = 0
	else:
		p_look_at_cam.priority = 0
		await get_tree().process_frame
		if p_main_camera.is_tweening:
			await p_main_camera.tween_completed
	
	p_look_at_cam.reparent(pivot)
	sequence_finished.emit()

func idle_interact():
	var targets = throw_raycast_grid()
	var best_target : Interactable = _get_most_central_target(targets)
	if best_target != last_best_target:
		if last_best_target:
			last_best_target.mouse_exited()
		
	if best_target:
		best_target.interact()

	last_best_target = best_target

func throw_raycast_grid() -> Array[Interactable]:
	var hit_interactables: Array[Interactable] = []
	var steps = 5
	var grid_size = 0.2
	var step_size = grid_size / (steps - 1) 
	var start_offset = -grid_size / 2.0 

	for row in range(steps):
		for col in range(steps):
			var x_offset = start_offset + (col * step_size)
			var y_offset = start_offset + (row * step_size)
			var local_offset = Vector3(x_offset, y_offset, 0)
			
			var hit = throw_raycast_with_offset(2.5, 0b1, local_offset)
			
			if hit.has("collider") and hit.collider is Interactable:
				if not hit_interactables.has(hit.collider):
					hit_interactables.append(hit.collider)
					
	return hit_interactables

func _get_most_central_target(ray_results: Array[Interactable]) -> Interactable:
	if ray_results.is_empty():
		return null

	var closest_obj: Interactable = null
	var max_dot = -1.0
	var camera_forward = -global_transform.basis.z

	for collider in ray_results:
		# Calculamos la dirección desde la cámara hacia el centro del objeto interactuable
		var direction_to_obj = (collider.global_position - global_position).normalized()
		var dot_product = camera_forward.dot(direction_to_obj)
		
		if dot_product > max_dot:
			max_dot = dot_product
			closest_obj = collider

	return closest_obj

func zoom():
	if Input.is_action_just_pressed("zoom"):
		var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "fov", zoom_in_fov, 0.3)
		tween.tween_property($"../Hud/VFX", "modulate", Color.TRANSPARENT, 0.3)
	elif Input.is_action_just_released("zoom"):
		var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "fov", default_zoom_fov, 0.3)
		tween.tween_property($"../Hud/VFX", "modulate", Color.WHITE, 0.3)
		
	
