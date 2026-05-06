class_name TapeStored
extends Interactable

@export var tape_resource : TapeResource
@onready var tape_mesh: Node3D = $TapeMesh
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var label_3d: RichText3D = $TapeMesh/Label3D

signal tape_selected(tape_resource : TapeResource)

func on_look() -> void:
	label_3d.text = tape_resource.name
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(tape_mesh, "position:y", 0.3, 0.4)
	tween.tween_property(collision_shape_3d, "position:y", 0.3-0.128, 0.4)
	tween.tween_property(label_3d, "transparency", 0.0, 0.4)

func on_mouse_exited() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(tape_mesh, "position:y", 0.0, 0.4)
	tween.tween_property(collision_shape_3d, "position:y", -0.128, 0.4)
	tween.tween_property(label_3d, "transparency", 1.0, 0.4)

func interact() -> void:
	if is_interacting:
		return
	
	on_look()
	
	set_process_input(true)
	inventory.can_be_opened = false
	mouse_interaction()

func mouse_interaction() -> void:
	if Input.is_action_just_pressed("select_item"):
		tape_selected.emit(tape_resource)
