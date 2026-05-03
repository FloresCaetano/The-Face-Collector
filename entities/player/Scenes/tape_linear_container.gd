class_name TapeContainer
extends Marker3D

@onready var p_rcam : PlayerRealCamera = PATHS.player_real_camera

var tape_stored_scene_path : NodePath = "uid://43brsodmfjul"
@export var animation_player: AnimationPlayer
@export var harry_arms: Node3D

var tapes : Array[TapeStored] = []
var spacing : float = 0.05


func show_box() -> void:
	harry_arms.visible = true
	animation_player.play("lift_box")
	

func hide_box() -> void:
	harry_arms.visible = false
	animation_player.play("lift_box", -1, true)

func add_tape(tape_resource : TapeResource) -> void:
	var tape_stored_scene : PackedScene = load(tape_stored_scene_path)
	var tape_stored : TapeStored = tape_stored_scene.instantiate() as TapeStored
	tape_stored.tape_resource = tape_resource
	tapes.append(tape_resource)
	add_child(tape_stored)
	tape_stored.tape_selected.connect(_on_tape_selected)
	
	_arrange_children()

func _arrange_children() -> void:
	var start_x = 0.0
	
	for i in range(tapes.size()):
		var tape = tapes[i]
		tape.position = Vector3(start_x + i * spacing, 0, 0)

func _on_tape_selected(tape : TapeResource):
	PATHS.cassette_tape_player._on_tape_selected(tape)
