extends Node

@onready var cassette_tape_player = PATHS.cassette_tape_player
@onready var audio_controller = PATHS.audio_controller

@onready var sixth_tape_left_audio : AudioStream = preload("uid://c04aj8prbvo67")
@onready var sixth_tape_right_audio : AudioStream = preload("uid://bjjl4syjjqldr")

func _ready() -> void:
	cassette_tape_player.event_triggered.connect(_on_event_triggered)
	cassette_tape_player.triggers.append({
		"timestamp": 57.995,
		"event": "sixth_tape_left_audio"
	})
	cassette_tape_player.triggers.append({
		"timestamp": 60.197,
		"event": "sixth_tape_right_audio"
	})

func _on_event_triggered(tape_tag, trigger_event) -> void:
	if tape_tag == "sixth_tape":
		match trigger_event:
			"sixth_tape_left_audio":
				audio_controller.left_simple_play(sixth_tape_left_audio)
			"sixth_tape_right_audio":
				audio_controller.right_simple_play(sixth_tape_right_audio)