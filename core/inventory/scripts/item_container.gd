class_name ItemContainer
extends CenterContainer

@onready var inventory : Inventory = PATHS.inventory

@export var item_image: TextureRect
@export var item_name: Label

@export_category("Options Container")
@export var btn_inspect : Button
@export var btn_use : Button


@export var item : Item = null
var mouse_is_over = false
var active_tween : Tween = null

var resize_factor : Vector2 = Vector2(1.1, 1.1)

signal item_inspected(item : Item)

func _ready() -> void:
	inventory.inventory_closed.connect(_on_inventory_closed)

func load_item():
	item_image.texture = item.texture
	item_name.text = item.name

func _on_mouse_entered() -> void:
	if active_tween: active_tween.stop()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(item_image, "modulate:a", 1.0, 0.2)
	active_tween = tween

	mouse_is_over = true


func lose_focus() -> void:
	if active_tween: active_tween.stop()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(item_image, "modulate:a", 0.4, 0.2)
	active_tween = tween

	mouse_is_over = false

func _process(_delta):
	if mouse_is_over:
		if Input.is_action_just_pressed("select_item"):
			item_inspected.emit(item)
	
	if mouse_is_over:
		var mouse_pos = get_global_mouse_position()
		var rect = Rect2(global_position, size)
		if not rect.has_point(mouse_pos):
			lose_focus()

func _on_inventory_closed() -> void:
	lose_focus()

func _on_item_container_gui_input(event: InputEvent) -> void:
	if event.is_action_released("select_item"):
		item_inspected.emit(item)
