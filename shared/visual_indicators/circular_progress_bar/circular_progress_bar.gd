class_name CircularProgressBar
extends Sprite3D

@onready var texture_progress_bar: TextureProgressBar = $SubViewport/CenterContainer/TextureProgressBar

func _ready() -> void:
	texture_progress_bar.value = 0

func set_value(value : float) -> void:
	texture_progress_bar.value = value
