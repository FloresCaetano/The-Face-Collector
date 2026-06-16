class_name ContextualInventory
extends Control

@export var items: HBoxContainer
@export_file_path("*.tscn") var item_container_path : String

var item_list : Array[Item]
var is_open := false
signal item_selected(item : Item)

func _ready() -> void:
	close()

func _on_item_selected(item : Item) -> void:
	item_selected.emit(item)

func open() -> void:
	load_items()
	visible = true

func close():
	visible = false
	for item_container in items.get_children():
		item_container.queue_free()

func load_items()-> void:
	for item in item_list:
		var item_container : ItemContainer = load(item_container_path).instantiate()
		item_container.item = item
		items.add_child(item_container)
		item_container.load_item()
		item_container.item_inspected.connect(_on_item_selected)
