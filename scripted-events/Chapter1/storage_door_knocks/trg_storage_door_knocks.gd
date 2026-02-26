extends Node3D

@onready var cassete_tape_player : CassetteTapePlayer = PATHS.cassette_tape_player
@export var audio_stream_player : AudioStreamPlayer3D

var already_heared_third_tape : bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player and already_heared_third_tape:
		audio_stream_player.play() #TODO: Add a unlocking sound after this
		await audio_stream_player.finished
		queue_free()

func _ready() -> void:
	cassete_tape_player.tape_finished.connect(_on_tape_finished)

func _on_tape_finished(tape : TapeResource) -> void:
	if tape.tag == "third_tape" and not already_heared_third_tape:
		already_heared_third_tape = true