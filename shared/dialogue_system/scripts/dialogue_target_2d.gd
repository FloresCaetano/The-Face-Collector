class_name DialogueTarget2D
extends DialogueTarget

@export var target_id: String
@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var is_selected : bool :
	set(value):
		is_selected = value
		selected.emit(value)
		
signal selected(value)

func select():
	is_selected = true
	label.text = ""

func deselect():
	is_selected = false
	label.text = ""

func set_text(text : RefCounted):
	label.text += text.char
	audio_stream_player.play()
