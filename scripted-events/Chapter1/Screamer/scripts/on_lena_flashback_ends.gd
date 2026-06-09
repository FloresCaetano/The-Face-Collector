extends Node

@export var cassette_tape_player: CassetteTapePlayer
@export var fp_screamer_trigger_scene : PackedScene
var screamer_look_at_trigger : VisibilityTrigger

@onready var audio_controller : AudioController = PATHS.audio_controller

@onready var collector: Node3D = $"../Collector"


func _ready() -> void:
	cassette_tape_player.flashback_ends.connect(_on_flashback_ends)

func _on_flashback_ends(uid : String) -> void:
	if not uid == "uid://brhm110k5epdl":
		return
	audio_controller.set_selected_tracks([])
	$"../AudioStreamPlayer2".play()
	$LookAtTrigger.entered_view.connect(_on_screamer_look)


func _on_screamer_look() -> void:
	collector.visible = true
	$"../AnimationPlayer".play("jumpscare")
	
