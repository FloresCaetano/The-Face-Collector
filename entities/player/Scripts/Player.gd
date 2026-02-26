class_name Player
extends CharacterBody3D
#
var drag_data
var drag_target_data
@export var pivot : Pivot
@onready var camera : Camera = PATHS.camera
@onready var mouse_ray_cast = $Pivot/Camera3D/MouseRayCast
@export var player_spotlight : SpotLight3D

#FLAGS
var can_move : bool = true
var can_jump : bool = true
var is_jumping : bool = false
var on_debug := false
var last_part_started : bool = false

#MOVE
var max_speed = 3.0
var sprint_speed = 3.0
var acceleration = 0.5
var desaceleration = 0.5
var can_footstep : bool = true

#JUMP
var max_height = 0.7
var jump_strength : float = 2
var reference_jump_height : float
var gravity = 25 #25

#STAIRS
const MAX_STEP_HEIGHT = 0.2
var _snaped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF
var snap_speed : float = 0.02


func _physics_process(delta):
	if is_on_floor(): _last_frame_was_on_floor = Engine.get_physics_frames()
	sprint()
	move(delta, get_input())

	if player_spotlight:
		flashlight_delay()

func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	%StairsBelowRaycast.force_raycast_update()
	var floor_below : bool = %StairsBelowRaycast.is_colliding() and not is_surface_too_step(%StairsBelowRaycast.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() == _last_frame_was_on_floor
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snaped_to_stairs_last_frame) and floor_below:
		var body_test_result = KinematicCollision3D.new()
		if self.test_move(self.global_transform, Vector3(0,-MAX_STEP_HEIGHT,0), body_test_result):
			#_save_camera_pos_for_smoothing()
			var translate_y = body_test_result.get_travel().y
			var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "position", position + Vector3(0, translate_y, 0), snap_speed)
			apply_floor_snap()
			did_snap = true
	_snaped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snaped_to_stairs_last_frame: return false
	# Don't snap stairs if trying to jump, also no need to check for stairs ahead if not moving
	if self.velocity.y > 0 or (self.velocity * Vector3(1,0,1)).length() == 0: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# Run a body_test_motion slightly above the pos we expect to move to, towards the floor.
	#  We give some clearance above to ensure there's ample room for the player.
	#  If it hits a step <= MAX_STEP_HEIGHT, we can teleport the player on top of the step
	#  along with their intended motion forward.
	var down_check_result = KinematicCollision3D.new()
	if (self.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") and down_check_result.get_collider().is_in_group("climbeable"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# Note I put the step_height <= 0.01 in just because I noticed it prevented some physics glitchiness
		# 0.02 was found with trial and error. Too much and sometimes get stuck on a stair. Too little and can jitter if running into a ceiling.
		# The normal character controller (both jolt & default) seems to be able to handled steps up of 0.1 anyway
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - self.global_position).y > MAX_STEP_HEIGHT: return false
		%StairsRaycast.global_position = down_check_result.get_position() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		%StairsRaycast.force_raycast_update()
		if %StairsRaycast.is_colliding() and not is_surface_too_step(%StairsRaycast.get_collision_normal()):
			var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "global_position", step_pos_with_clearance.origin + down_check_result.get_travel(), snap_speed)
			apply_floor_snap()
			_snaped_to_stairs_last_frame = true
			return true
	return false

func is_surface_too_step(normal : Vector3):
	return normal.angle_to(Vector3.UP) > self.floor_max_angle
	
func _run_body_test_motion(from: Transform3D, motion : Vector3, result = null):
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func flashlight_delay():
	var tween2 : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween2.tween_property(player_spotlight, "global_transform", camera.global_transform, 0.24)

func move(delta, input):
	var impulse : Vector3
	impulse = Vector3(
		transform.basis.x.x * input.x + transform.basis.z.x * input.z,
		0,
		transform.basis.x.z * input.x + transform.basis.z.z * input.z
		).normalized() * max_speed
	
	if last_part_started:
		impulse = Vector3(1, 0, 0) * max_speed
	
	velocity.y -= gravity * delta
	if input.x != 0 or input.z != 0:
		velocity.x = lerp(velocity.x, impulse.x, acceleration)
		velocity.z = lerp(velocity.z, impulse.z, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, desaceleration)
		velocity.z = lerp(velocity.z, 0.0, desaceleration)
	
	if not _snap_up_stairs_check(delta):
		move_and_slide()
		_snap_down_to_stairs_check()

func sprint():
	if(Input.is_action_pressed("sprint")):
		max_speed = sprint_speed
	else:
		max_speed = 3.0

func get_input():
	var input = Vector3()
	if can_move:
		if Input.is_action_pressed("m_forward"):
			input.z += 1
		if Input.is_action_pressed("m_backwards"):
			input.z -= 1
		if Input.is_action_pressed("m_left"):
			input.x += 1
		if Input.is_action_pressed("m_right"):
			input.x -= 1
	return input

func play_footsteps():
	var collider = $CheckFloorMaterialRay.get_collider()
	if not collider:
		return

func _on_footsteps_finished():
	can_footstep = true

func desactivate():
	can_move = false
	pivot.cameraLock = true

func activate():
	can_move = true
	pivot.cameraLock = false

func _on_footsteps_timer_timeout():
	can_footstep = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.is_in_group("player")):
		$"../AudioStreamPlayer3D".play()
		$"../Area3D".queue_free()
