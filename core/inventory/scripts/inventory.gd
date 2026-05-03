class_name Inventory
extends Control

@export var item_list: VBoxContainer
@export var player : Player
@export var inspect_container : InspectContainer

var is_open = false
var can_be_opened = true
var can_be_closed = true
var can_inspect_items = true

var last_item_selected : Item = null

signal inventory_closed

func _ready() -> void:
	pass
	#SIGNALBUS.item_selected.connect(
	#	func(item : Item) -> void:
	#		last_item_selected = item
	#)
	#close()

func open():
	player.desactivate()
	visible = true
	is_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close():
	player.activate()
	visible = false
	is_open = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	reset_vars()
	inventory_closed.emit() #USED TO NOTIFY ITEM CONTAINERS TO HIDE OPTIONS, RESET BUTTON STATES AND DESINSPECT ITEMS

func add_item(item : Item) -> void:
	var item_container : ItemContainer = load("uid://cipflgtvarr0m").instantiate()
	item_container.item = item
	item_container.load_item()
	item_list.add_child(item_container)

func remove_item(item : Item) -> void:
	for i in item_list.get_children():
		if i.item == item:
			item_list.remove_child(i)
			i.queue_free()
			return

func remove_item_by_tag(item_tag : String) -> void:
	for i in item_list.get_children():
		if i.item.tag == item_tag:
			item_list.remove_child(i)
			i.queue_free()

			if inspect_container.is_inspecting:
				inspect_container.stop_inspecting()
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
	if not is_open:
		if can_be_opened and Input.is_action_just_pressed("open_inventory"):
			open()
	else:
		if can_be_closed and Input.is_action_just_pressed("scape"):
			close()

func reset_vars() -> void:
	can_be_opened = true
	can_be_closed = true
	can_inspect_items = true
