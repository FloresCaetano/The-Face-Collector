class_name VisibilityTrigger
extends VisibleOnScreenNotifier3D

@onready var camera_host : PlayerRealCamera = PATHS.player_real_camera
@export var free_on_exit : bool = true

signal entered_view
signal left_view



func _ready() -> void:
	set_process(false)

func _on_screen_entered() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, camera_host.get_global_position())
	query.collision_mask = 0b1001
	var result = space_state.intersect_ray(query)
	
	if result and result.collider is Player:
		entered_view.emit()
		set_process(false)


func _on_screen_exited() -> void:
	left_view.emit()
