class_name MouseRotator3D
extends Node3D

@onready var player_rcam: Camera3D = PATHS.player_real_camera

signal rotation_updated(total_rotation_degrees: float)
signal turn_completed

enum RotationMode {
	BOTH,
	ONLY_RIGHT,
	ONLY_LEFT
}

@export var is_active: bool = true : set = _set_is_active
@export var direccion_permitida: RotationMode = RotationMode.BOTH

var rotation_delta: float = 0.0
var rotation_delta_degrees: float = 0.0
var total_rotation_radians: float = 0.0
var _turns_count: int = 0

var screen_pivot: Vector2 = Vector2.ZERO
var previous_angle: float = 0.0
var has_initialized: bool = false
var latest_mouse_position: Vector2 = Vector2.ZERO
var mouse_moved_this_frame: bool = false

func _ready() -> void:
	latest_mouse_position = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if not is_active:
		return
	if event is InputEventMouseMotion:
		latest_mouse_position = event.position
		mouse_moved_this_frame = true

func _process(_delta: float) -> void:
	if not is_active:
		_clear_deltas()
		return

	if not player_rcam or player_rcam.is_position_behind(global_position):
		_clear_deltas()
		return

	screen_pivot = player_rcam.unproject_position(global_position)

	if not mouse_moved_this_frame:
		rotation_delta = 0.0
		rotation_delta_degrees = 0.0
		return

	var direction: Vector2 = latest_mouse_position - screen_pivot
	var current_angle: float = atan2(direction.y, direction.x)

	if not has_initialized:
		previous_angle = current_angle
		has_initialized = true
		mouse_moved_this_frame = false
		return

	var delta_angle: float = current_angle - previous_angle

	if delta_angle > PI:
		delta_angle -= 2.0 * PI
	elif delta_angle <= -PI:
		delta_angle += 2.0 * PI

	if direccion_permitida == RotationMode.ONLY_RIGHT and delta_angle < 0.0:
		delta_angle = 0.0
	elif direccion_permitida == RotationMode.ONLY_LEFT and delta_angle > 0.0:
		delta_angle = 0.0

	rotation_delta = delta_angle
	rotation_delta_degrees = rad_to_deg(delta_angle)
	total_rotation_radians += delta_angle
	
	previous_angle = current_angle

	rotation_updated.emit(rad_to_deg(total_rotation_radians))

	var new_turns: int = int(total_rotation_radians / (2.0 * PI))

	if new_turns != _turns_count:
		_turns_count = new_turns
		turn_completed.emit()

	mouse_moved_this_frame = false

func _clear_deltas() -> void:
	rotation_delta = 0.0
	rotation_delta_degrees = 0.0

func _set_is_active(value: bool) -> void:
	is_active = value
	if not is_active:
		_clear_deltas()
		has_initialized = false

func reset() -> void:
	total_rotation_radians = 0.0
	_turns_count = 0
	_clear_deltas()
	has_initialized = false
