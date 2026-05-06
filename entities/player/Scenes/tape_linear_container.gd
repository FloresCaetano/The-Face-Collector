class_name TapeLinearContainer
extends Marker3D

@onready var p_rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var inventory : Inventory = PATHS.inventory

var tape_stored_scene_path : NodePath = "uid://43brsodmfjul"
@export var animation_player: AnimationPlayer
@export var harry_arms: Node3D

var tapes : Array[TapeStored] = []
var spacing : float = 0.05

signal tape_selected(tape : TapeResource)

func reload_tapes():
	clear_tapes()
	for item in inventory.get_items():
		if item is TapeResource:
			add_tape(item)

func clear_tapes():
	for tape in tapes:
		tape.queue_free()
	tapes.clear()

func add_tape(tape_resource : TapeResource) -> void:
	var tape_stored_scene : PackedScene = load(tape_stored_scene_path)
	var tape_stored : TapeStored = tape_stored_scene.instantiate() as TapeStored
	tape_stored.tape_resource = tape_resource
	tapes.append(tape_stored)
	add_child(tape_stored)
	tape_stored.tape_selected.connect(_on_tape_selected)
	
	_arrange_children()

func _arrange_children() -> void:
	var start_x = 0.0
	
	for i in range(tapes.size()):
		var tape = tapes[i]
		tape.position = Vector3(start_x + i * spacing, 0, 0)

func _on_tape_selected(tape_resource : TapeResource):
	tape_selected.emit(tape_resource)
