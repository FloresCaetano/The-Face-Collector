extends Node

####INVENTORY RELATED SIGNALS####
signal tape_selected(tape : TapeResource)
func _on_tape_selected(tape : TapeResource) -> void:
	tape_selected.emit(tape)

signal item_inspected(item : Item)
func _on_item_inspected(item : Item) -> void:
	item_inspected.emit(item)
