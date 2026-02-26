class_name Plank
extends Interactable

@export var timer : Timer
@onready var inventory : Inventory = PATHS.inventory

signal plank_removed

func _ready() -> void:
	set_process_input(false)
	set("sleeping", true)
	set("freeze", true)

func mouse_interaction() -> void:
	if Input.is_action_just_pressed("interact") and not is_interacting:
		set_process_input(true)
		inventory.open()
		inventory.can_be_closed = false
		inventory.can_be_opened = false
		inventory.can_inspect_items = false
		is_interacting = true
		SIGNALBUS.item_selected.connect(_on_item_selected)

func _on_item_selected(item : Item) -> void:
	if item.tag == "hammer":
		#TODO Add some kind of "you broke the plank" animation and sound effect.
		set("sleeping", false)
		set("freeze", false)
		call("apply_force", Vector3(0, 0, 100) * transform.basis, Vector3(0.2, 0, 0))
		inventory.reset_vars()
		inventory.close()
		is_interacting = false
		set_process_input(false)
		SIGNALBUS.item_selected.disconnect(_on_item_selected)

		plank_removed.emit()
		timer.start()

func _input(_event):
	if Input.is_action_just_pressed("scape") and is_interacting:
		inventory.reset_vars()
		inventory.close()
		SIGNALBUS.item_selected.disconnect(_on_item_selected)
		is_interacting = false
		set_process_input(false)

func on_mouse_exited() -> void:
	pass


func _on_timer_timeout() -> void:
	queue_free()