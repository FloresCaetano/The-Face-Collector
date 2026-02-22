extends Node

####INVENTORY RELATED SIGNALS####
signal item_selected(item : Item)
func _on_item_selected(item : Item) -> void:
	item_selected.emit(item)

signal item_inspected(item : Item)
func _on_item_inspected(item : Item) -> void:
	item_inspected.emit(item)