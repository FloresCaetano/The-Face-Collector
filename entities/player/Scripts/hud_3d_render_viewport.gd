extends SubViewportContainer

@export var sub_viewport: SubViewport
@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera

func _ready() -> void:
	$SubViewport/Camera3D.fov = player_rcam.fov
	get_tree().root.size_changed.connect(_on_window_resized)
	
	await get_tree().process_frame
	update_sub_viewport_size()


func _on_window_resized() -> void:
	update_sub_viewport_size()

func update_sub_viewport_size() -> void:
	sub_viewport.size = self.size

func _process(delta: float) -> void:
	$SubViewport/Camera3D.global_transform = player_rcam.global_transform
