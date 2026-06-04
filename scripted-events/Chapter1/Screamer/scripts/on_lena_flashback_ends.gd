extends Node

@export var cassette_tape_player: CassetteTapePlayer
@export var fp_screamer_trigger_scene : PackedScene
var screamer_look_at_trigger : VisibilityTrigger

func _ready() -> void:
	cassette_tape_player.flashback_ends.connect(_on_flashback_ends)


func _on_flashback_ends(uid : String) -> void:
	if not uid == "uid://brhm110k5epdl":
		return
	var fp_screamer_trigger = fp_screamer_trigger_scene.instantiate()
	add_sibling(fp_screamer_trigger)
	$LookAtTrigger.entered_view.connect(_on_screamer_look)


func _on_screamer_look() -> void:
	$"../FpScreamerManager/FpAnimationManager".start_animation("Screamer")
