@abstract
class_name DialogueTarget
extends Node

@export var target_id: String
@onready var label = $Label
@onready var audio_stream_player = $AudioStreamPlayer
var pitch_range

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
	pitch_range = actual_line["PITCH-RANGE"].split("-")
	
	label.visible_ratio = 0.0
	label.text = line
	

func on_actual_line_change():
	pass
