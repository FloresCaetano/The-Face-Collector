@abstract
class_name Interactable
extends PhysicsBody3D

var is_interacting := false

@onready var player : Player = PATHS.player
@onready var inventory : Inventory = PATHS.inventory

@abstract
func mouse_interaction() -> void
@abstract
func on_mouse_exited() -> void

func on_interaction_leave() -> void:
	pass



func interact() -> void:
	set_process_input(true)
	is_interacting = true
	inventory.can_be_opened = false
	mouse_interaction()

func leave_interaction() -> void:
		player.activate()
		is_interacting = false
		set_process_input(false)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		inventory.reset_vars()
		on_interaction_leave()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("scape") and is_interacting:
		leave_interaction()
