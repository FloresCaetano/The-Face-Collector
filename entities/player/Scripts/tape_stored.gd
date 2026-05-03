class_name TapeStored
extends Interactable

@export var tape_resource : TapeResource
@onready var tape_mesh: Node3D = $TapeMesh

signal tape_selected(tape_resource : TapeResource)

func on_look() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(tape_mesh, "position:y", 0.3, 0.4)

func mouse_interaction() -> void:
	tape_selected.emit()

func on_mouse_exited() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(tape_mesh, "position:y", 0.0, 0.4)
