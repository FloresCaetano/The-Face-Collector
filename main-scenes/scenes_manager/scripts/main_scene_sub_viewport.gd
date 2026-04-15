extends SubViewportContainer

@export var sub_viewport: SubViewport

func _ready() -> void:
	get_tree().root.size_changed.connect(_on_window_resized)
	
	await get_tree().process_frame
	update_sub_viewport_size()


func _on_window_resized() -> void:
	update_sub_viewport_size()

func update_sub_viewport_size() -> void:
	sub_viewport.size = self.size
