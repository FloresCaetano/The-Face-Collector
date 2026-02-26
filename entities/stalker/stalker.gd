extends Node3D

@export var path_follow : PathFollow3D
@export var player_detection_barriers : Array[Area3D]

@export_category("Stalker Settings")
@export var speed : float = 1.0
@export var stopping_points : Array[float] = [12.3, 22.55, 35.85, 47.04]

var tween : Tween
func move_to_point(index : int) -> void:
	if index == 0:
		path_follow.progress = 0.0

	var distance_to_point = abs(path_follow.progress - stopping_points[index])
	if tween and tween.is_running(): tween.stop()

	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(path_follow, "progress", stopping_points[index], distance_to_point / speed)

func _on_barrier_body_entered(body, barrier) -> void:
	var idx = int(barrier.name)
	
	if body is Player:
		barrier.set_deferred("monitoring", false)
		var next_barrier_idx = idx + 1 if idx + 1 < player_detection_barriers.size() else 0
		player_detection_barriers[next_barrier_idx].set_deferred("monitoring", true)
		move_to_point(idx)
		

func _ready() -> void:
	for barrier in player_detection_barriers:
		barrier.body_entered.connect(_on_barrier_body_entered.bind(barrier))
