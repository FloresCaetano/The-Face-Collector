extends EventBehavior
@export var last_player_position: Marker3D

func execute() -> void:
	PATHS.player.global_position = last_player_position.global_position
	get_parent().is_interacting = false
