class_name Inventory
extends Control

@export var item_list: VBoxContainer
@export var inspect_container : InspectContainer
@export var sub_viewport: SubViewport
@export var text_container: TextContainer
@export var item_scroll_container: ScrollContainer

@onready var player : Player = PATHS.player
@onready var p_rcam : PlayerRealCamera = PATHS.player_real_camera

var is_open = false
var can_be_opened = true
var can_be_closed = true
var can_inspect_items = true

var last_item_selected : Item = null

signal inventory_closed
signal item_inspected(item : Item)

func _ready() -> void:
	close()

func open():
	player.desactivate()
	await p_rcam.change_state(p_rcam.State.BLOQUED)
	visible = true
	is_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	sub_viewport.handle_input_locally = true

func close():
	player.activate()
	p_rcam.change_state(p_rcam.State.IDLE)
	visible = false
	is_open = false
	
	close_text_container()
	
	reset_vars()
	inventory_closed.emit() #USED TO NOTIFY ITEM CONTAINERS TO HIDE OPTIONS, RESET BUTTON STATES AND DESINSPECT ITEMS
	sub_viewport.handle_input_locally = false

func add_item(item : Item) -> void:
	var item_container : ItemContainer = load("uid://cipflgtvarr0m").instantiate()
	item_container.item = item
	item_container.load_item()
	item_list.add_child(item_container)
	item_container.item_inspected.connect(_on_item_inspected)

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

func get_items_by_tag(item_tag : String) -> Array[Item]:
	var items : Array[Item] = []
	for i in item_list.get_children():
		if i.item.tag == item_tag:
			items.append(i.item)
	return items

func has_item(item_tag : String) -> int:
	var ammount : int = 0
	for i in item_list.get_children():
		if i.item.tag == item_tag:
			ammount += 1
	return ammount

func has_item_by_class(item_class : String) -> int:
	var ammount : int = 0
	for i in item_list.get_children():
		var item : Item = i.item
		if item.is_class(item_class):
			ammount += 1
	return ammount

func get_items() -> Array[Item]:
	var items : Array[Item] = []
	for i in item_list.get_children():
		items.append(i.item)
	return items

func _input(_event):
	if Input.is_action_just_pressed("open_inventory"):
		if PATHS.player_real_camera.actual_state == PATHS.player_real_camera.State.IDLE:
			if not is_open: open()
		elif is_open:
			close()

func reset_vars() -> void:
	can_be_opened = true
	can_be_closed = true
	can_inspect_items = true


func _on_item_inspected(item: Item) -> void:
	if not can_inspect_items:
		return
	
	last_item_selected = item
	item_inspected.emit(item)

func open_text_container(text : String):
	text_container.set_text(text)
	item_scroll_container.visible = false
	text_container.visible = true
	sub_viewport.size.x = 900
	

func close_text_container():
	item_scroll_container.visible = true
	text_container.visible = false
	sub_viewport.size.x = 1030
