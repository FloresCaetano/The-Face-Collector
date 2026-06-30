class_name InspectContainer
extends SubViewportContainer

var is_mouse_on_container = false
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
@export var pivot: Node3D
@export var pitch: Node3D


func _ready() -> void:
	get_window().size_changed.connect(_on_window_size_changed)
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
	if not is_inspecting:
		return
	
	if not Rect2(Vector2.ZERO, size).has_point(get_local_mouse_position()):
		return
	
	if Input.is_action_just_pressed("inspect_zoom_in") and camera.position.z >= 0.2:
		var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(camera, "position", camera.position - Vector3(0, 0, 0.1), 0.1)
	elif Input.is_action_just_pressed("inspect_zoom_out") and camera.position.z <= 1:
		var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(camera, "position", camera.position + Vector3(0, 0, 0.1), 0.1)
	
	if current_item_model == null or rotation_velocity.length() < 0.0001:
		return
	
	pitch.rotation.y -= rotation_velocity.x
	pivot.rotation.x -= rotation_velocity.y
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
	
	camera.position = -(Vector3(0, 0, -0.3) + item.offset)
	pitch.rotation.y = -(item.rot_offset.y)
	pivot.rotation.x = -(item.rot_offset.x)
	get_child(0).add_child(current_item_model)

func _on_inventory_closed() -> void:
	stop_inspecting()

func stop_inspecting():
	is_inspecting = false
	dragging = false
	if current_item_model:
		current_item_model.queue_free()
		current_item_model = null


func _on_window_size_changed() -> void:
	await get_tree().process_frame
	sub_viewport.size = Vector2(1366, 768)
