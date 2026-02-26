extends Node3D
@export var active : bool = true
@onready var Point_to_camera_ray = $point_to_camera_ray
@onready var Distance_ray = $distance_ray
@onready var Player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var PlayerCamera : Camera3D = Player.get_node("Pivot/Camera3D")

#FLAGS
var screen_entered = false
signal on_screen_entered

func _process(_delta: float) -> void:
	Point_to_camera_ray.target_position = Point_to_camera_ray.to_local(PlayerCamera.global_position)
	if is_on_camera() and not screen_entered:
		on_screen_entered.emit()
		screen_entered = true
	if not is_on_camera() and screen_entered:
		screen_entered = false

func is_on_camera():
	return Point_to_camera_ray.is_colliding() and Point_to_camera_ray.get_collider() == Player

func get_distance():
	Distance_ray.target_position = Distance_ray.to_local(PlayerCamera.global_position)
	var distance : float = abs(global_position - Distance_ray.get_collision_point()).length()
	return distance
