extends Node


signal item_selected(item : Item)
func _on_item_selected(item : Item) -> void:
	emit_signal("item_selected", item)