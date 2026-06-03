extends Node

@export var cassette_tape_player: CassetteTapePlayer

func _ready() -> void:
	cassette_tape_player.flashback_ends.connect(_on_flashback_ends)


func _on_flashback_ends() -> void:
	return
