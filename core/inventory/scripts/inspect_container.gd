extends SubViewportContainer

var is_inspecting = false

var dragging = false
var last_mouse_position = Vector2()
var rotation_velocity = Vector3.ZERO  # Velocidad de rotación acumulada
var rotation_damping = 0.95  # Factor de amortiguamiento
var rotation_sensitivity = 0.001  # Sensibilidad de rotación

@onready var inventory = PATHS.inventory
@export var sub_viewport : SubViewport


func _ready() -> void:
	SIGNALBUS.item_inspected.connect(_on_item_inspected)
	inventory.open()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_inspecting:
			dragging = true
			last_mouse_position = event.position
			rotation_velocity = Vector3.ZERO  # Resetear velocidad al comenzar a arrastrar
		elif not event.pressed:
			dragging = false

	if dragging and event is InputEventMouseMotion:
		var delta = event.position - last_mouse_position
		rotation_velocity.x += delta.y * rotation_sensitivity
		rotation_velocity.y += delta.x * rotation_sensitivity
		last_mouse_position = event.position

func _process(_delta):
	sub_viewport.size = self.size
	if !rotation_velocity == Vector3.ZERO:
		var item = get_child(0).get_child(2)
		item.rotate(Vector3.UP, rotation_velocity.y)
		item.rotate(Vector3.RIGHT, rotation_velocity.x)
		rotation_velocity *= rotation_damping
		if rotation_velocity.length() < 0.001:
			rotation_velocity = Vector3.ZERO

func _on_item_inspected(item):
	if item == null:
		is_inspecting = false
		get_child(0).get_child(2).queue_free()
		return
	
	is_inspecting = true
	rotation_velocity = Vector3.ZERO  # Resetear velocidad al inspeccionar nuevo objeto
	dragging = false  # Asegurar que no esté arrastrando
	var item_model = item.model.instantiate()
	item_model.position = Vector3(0, 0, -0.3) + item.offset
	get_child(0).add_child(item_model)


@onready var subviewport_container := self
@onready var subviewport := $SubViewport

func _unhandled_input(event):
	if event is InputEventMouse:
		var local_mouse = subviewport_container.get_local_mouse_position()
		var new_event = event.duplicate()
		new_event.position = local_mouse
		subviewport.push_input(new_event)
