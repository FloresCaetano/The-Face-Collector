extends SubViewport

@export var transition_camera: Camera3D

@onready var player_real_camera : PlayerRealCamera = PATHS.player_real_camera

func _ready() -> void:
	get_tree().root.size_changed.connect(_on_window_resized)
	
	await get_tree().process_frame
	update_sub_viewport_size()


func _on_window_resized() -> void:
	update_sub_viewport_size()

func update_sub_viewport_size() -> void:
	size = get_tree().root.size

func _process(_delta: float) -> void:
	transition_camera.global_transform = player_real_camera.global_transform
