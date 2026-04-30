class_name DialogueTarget2D
extends DialogueTarget

@export var target_id: String
@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer



func select():
	label.text = ""

func deselect():
	label.text = ""

func set_text(text : RefCounted):
	label.text += text.char
	audio_stream_player.play()
