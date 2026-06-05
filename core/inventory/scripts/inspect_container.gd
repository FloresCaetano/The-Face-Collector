class_name InspectContainer
extends SubViewportContainer

var is_inspecting = false
var current_item_model = null
var dragging = false
var last_mouse_pos = Vector2()
var rotation_velocity = Vector2.ZERO

const SENSITIVITY = 0.005
const DAMPING = 0.9

@onready var inventory = PATHS.inventory
@export var sub_viewport : SubViewport
@export var camera : Camera3D

func _ready() -> void:
	inventory.item_inspected.connect(_on_item_inspected)
	inventory.inventory_closed.connect(_on_inventory_closed)
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if not is_inspecting:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		last_mouse_pos = event.position
		if dragging:
			rotation_velocity = Vector2.ZERO

	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		rotation_velocity = delta * SENSITIVITY
		last_mouse_pos = event.position

func _process(_delta: float) -> void:
	sub_viewport.size = size
	
	if not is_inspecting or current_item_model == null or rotation_velocity.length() < 0.0001:
		return
	
	current_item_model.rotate(Vector3.UP, rotation_velocity.x)
	current_item_model.rotate(Vector3.RIGHT, rotation_velocity.y)
	rotation_velocity *= DAMPING

func _on_item_inspected(item) -> void:
	if current_item_model:
		current_item_model.queue_free()
		current_item_model = null
	
	if item == null:
		is_inspecting = false
		return
	
	is_inspecting = true
	dragging = false
	rotation_velocity = Vector2.ZERO
	current_item_model = item.model.instantiate()
	current_item_model.position = Vector3(0, 0, -0.3) + item.offset
	current_item_model.rotation = item.rot_offset
	get_child(0).add_child(current_item_model)

func _on_inventory_closed() -> void:
	stop_inspecting()

func stop_inspecting():
	is_inspecting = false
	dragging = false
	if current_item_model:
		current_item_model.queue_free()
		current_item_model = null
