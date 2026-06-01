@abstract
class_name DialogueTarget
extends Node

@export var target_id: String
@onready var label = $Label
@onready var audio_stream_player = $AudioStreamPlayer

var is_selected : bool :
	set(value):
		is_selected = value
		selected.emit(value)
		
signal selected(value)

var actual_line : Dictionary :
	set(value):
		actual_line = value
		var line : String = ""
		for token in value.text:
			line += token.char
		load_line(line)
		on_actual_line_change()

@abstract
func select()

@abstract
func deselect()

@abstract
func next_token()

func load_line(line : String):
	var pitch_range : PackedStringArray = actual_line["PITCH-RANGE"].split("-")
	var pitch : float = randf_range(pitch_range[0].to_float(), pitch_range[1].to_float())
	audio_stream_player.pitch_scale = pitch
	
	label.visible_ratio = 0.0
	label.text = line
	

func on_actual_line_change():
	pass
