class_name TextContainer
extends Control

@export var rich_text_label: RichTextLabel


func set_text(text : String) -> void:
	rich_text_label.text = text


func _on_texture_rect_pressed() -> void:
	PATHS.inventory.close_text_container()
