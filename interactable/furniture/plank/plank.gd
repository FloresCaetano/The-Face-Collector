class_name Plank
extends Interactable

@export var timer : Timer

signal plank_removed

func _ready() -> void:
	set_process_input(false)
	set("sleeping", true)
	set("freeze", true)

func mouse_interaction() -> void:
	if inventory.has_item("crowbar") > 0:
		set("sleeping", false)
		set("freeze", false)
		call("apply_force", Vector3(0, 0, 100) * transform.basis, Vector3(0.2, 0, 0))
		plank_removed.emit()

func on_mouse_exited() -> void:
	pass
