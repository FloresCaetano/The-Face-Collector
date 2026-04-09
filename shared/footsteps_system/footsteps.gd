extends Node3D

@export_category("configs")
@export var min_time : float = 1.0

@export_category("dependency_nodes")
@export var object : Node3D
@export var footsteps_player : AudioStreamPlayer3D
@export var footsteps_creaking : AudioStreamPlayer3D
@export var check_floor_ray_material : RayCast3D
@export var timer : Timer

enum floor_materials {
	wood, concrete, gravel
}

var footsteps_sound_library : Dictionary = {
	floor_materials.wood : "uid://dnixe0mwgvt6y",
	floor_materials.gravel : "uid://u8gl3qr4xb7d"
}

#Variable para rastrear la posición anterior
var last_position : Vector3 = Vector3.ZERO
var can_footstep = true

func _ready() -> void:
	timer.timeout.connect(_on_footsteps_finished)
	if object:
		last_position = object.global_position

func _process(_delta: float) -> void:
	var floor : Node = check_floor_ray_material.get_collider()
	
	if not (object and floor):
		return
	
	# Calcular si el objeto se está moviendo
	var current_position = object.global_position
	var is_moving = (current_position - last_position).length() > 0.001
	
	
	if is_moving and can_footstep:
		var material : String = floor.get_groups()[0]
		_play_footstep(material)
		can_footstep = false
		timer.start(min_time)

	last_position = current_position

func _play_footstep(material : String) -> void:
	# Reproducir sonido de pasos
	if footsteps_player.playing or not footsteps_player:
		return
	
	if material == str(floor_materials.wood):
		# 10% de probabilidad de reproducir crujido
		if footsteps_creaking and randf() < 0.1:
			footsteps_creaking.play()
	
	footsteps_player.stream = load(footsteps_sound_library[floor_materials[material]])
	footsteps_player.play()
	
	

func _on_footsteps_finished() -> void:
	can_footstep = true
