class_name Inventory
extends Control

@export var item_list: VBoxContainer

var is_open = false
var can_be_opened = true
var can_be_closed = true
var can_inspect_items = true

func _ready() -> void:
	close()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
	reset_vars()

func add_item(item : Item) -> void:
	var item_container : ItemContainer = ItemContainer.new()
	item_container.item = item
	item_container.load_item()
	item_list.add_child(item_container)

func remove_item(item : Item) -> void:
	for i in item_list.get_children():
		if i.item == item:
			item_list.remove_child(i)
			i.queue_free()
			return

func get_item_at_index(index : int) -> Item:
	if index < 0 or index >= item_list.get_child_count():
		return null
	var item_container : ItemContainer = item_list.get_child(index)
	return item_container.item

func get_items() -> Array[Item]:
	var items : Array[Item] = []
	for i in item_list.get_children():
		items.append(i.item)
	return items

func _input(_event):
	if not can_be_closed:
		if is_open and Input.is_action_just_pressed("close_inventory"):
			close()

	if not can_be_opened:
		if not is_open and Input.is_action_just_pressed("open_inventory"):
			open()

func reset_vars() -> void:
	can_be_opened = true
	can_be_closed = true
	can_inspect_items = true