@abstract
class_name Interactable
extends PhysicsBody3D

@export var active := true
@export var can_leave := true
@export var interact_key : String = "interact"
@export var interaction_distance : float = 3.0

@export var indicator_last_pose_references : Array[Marker3D]
@export var indicator_size : Vector3 = Vector3(0.4, 0.4, 0.4)


@onready var player : Player = PATHS.player
@onready var inventory : Inventory = PATHS.inventory

var is_interacting := false
var interactable_indicators : Array[InteractableIndicator]

signal interacted


@abstract
func mouse_interaction() -> void
@abstract
func on_mouse_exited() -> void
func on_look() -> void: pass

func on_leave_interaction() -> void: pass

func interact() -> void:
	if not active:
		return
	
	if is_interacting:
		return
	
	if (player.global_position - global_position).length() > interaction_distance:
		mouse_exited()
		return
	
	if interactable_indicators.is_empty() and indicator_last_pose_references:
		for i in range(indicator_last_pose_references.size()):
			var indicator_last_pose_reference = indicator_last_pose_references[i]
			interactable_indicators.append(load("uid://c3aovnmj54oeg").instantiate() as InteractableIndicator)
			add_child(interactable_indicators[i])
			interactable_indicators[i].scale = Vector3.ZERO
			interactable_indicators[i].global_position = indicator_last_pose_reference.global_position
			interactable_indicators[i].grow(indicator_size / scale)
	
	on_look()
	
	if Input.is_action_just_pressed(interact_key):
		inventory.can_be_opened = false
		_delete_indicator()
		set_process_input(true)
		is_interacting = true
		inventory.can_be_opened = false
		mouse_interaction()

func leave_interaction() -> void:
		inventory.can_be_opened = true
		is_interacting = false
		set_process_input(false)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		on_leave_interaction()

func mouse_exited():
	_delete_indicator()
	on_mouse_exited()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("scape") and is_interacting and can_leave:
		leave_interaction()

func _delete_indicator():
	if not interactable_indicators.is_empty():
		for interactable_indicator in interactable_indicators:
			if interactable_indicator:
				await interactable_indicator.shrink()
				interactable_indicator.queue_free()
				interactable_indicator = null
		interactable_indicators.clear()
