class_name ContextualInventory
extends Control

@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera

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
	$MenuSounds.play()
	PATHS.fade_controller.blur_in(0.5)
	await PATHS.fade_controller.blur_in_finished
	PATHS.fade_controller.blur_out(0.5)
	player_rcam.change_state(player_rcam.State.BLOQUED)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	load_items()
	visible = true

func close():
	player_rcam.change_state(player_rcam.State.IDLE)
	visible = false
	for item_container in items.get_children():
		item_container.queue_free()
	await get_tree().create_timer(1.0).timeout
	PATHS.inventory.can_be_opened = true

func load_items()-> void:
	if not item_list:
		push_error("No items to load in contextual inventory")
		return
	
	for item in item_list:
		var item_container : ItemContainer = load(item_container_path).instantiate()
		item_container.item = item
		items.add_child(item_container)
		item_container.load_item()
		item_container.item_inspected.connect(_on_item_selected)
