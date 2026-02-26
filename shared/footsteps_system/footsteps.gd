extends Node3D

@export_category("configs")
@export var min_time : float = 1.0

@export_category("dependency_nodes")
@export var object : Node3D
@export var footsteps_player : AudioStreamPlayer3D
@export var footsteps_creaking : AudioStreamPlayer3D
@export var check_floor_ray_material : RayCast3D
@export var timer : Timer

# Variable para rastrear la posición anterior
var last_position : Vector3 = Vector3.ZERO
var can_footstep = true

func _ready() -> void:
	timer.timeout.connect(_on_footsteps_finished)
	if object:
		last_position = object.global_position

func _process(_delta: float) -> void:
	if not object:
		return
	
	# Calcular si el objeto se está moviendo
	var current_position = object.global_position
	var is_moving = (current_position - last_position).length() > 0.001
	
	if is_moving and can_footstep:
		_play_footstep()
		can_footstep = false
		timer.start(min_time)

	last_position = current_position

func _play_footstep() -> void:
	# Reproducir sonido de pasos
	if footsteps_player and not footsteps_player.playing:
		footsteps_player.play()
	
	# 10% de probabilidad de reproducir crujido
	if footsteps_creaking and randf() < 0.1:
		footsteps_creaking.play()

func _on_footsteps_finished() -> void:
	can_footstep = true