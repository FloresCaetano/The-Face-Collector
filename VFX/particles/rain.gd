extends GPUParticles3D

@export var player: Player
@export var speed: float = 0.1

func _process(delta: float) -> void:
	var target_pos : Vector3 = player.global_position
	global_position.x = lerp(global_position.x, target_pos.x, speed * delta)
	global_position.z = lerp(global_position.z, target_pos.z, speed * delta)
	
	
