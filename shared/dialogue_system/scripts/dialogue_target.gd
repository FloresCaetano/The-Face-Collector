@abstract
class_name DialogueTarget
extends Node

@export var target_id: String
@export var label : Node 
@export var dialogue_photo : TextureRect
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
	
	if not dialogue_photo:
		return
	
	var character : String = actual_line["CHARACTER"].to_lower()
	dialogue_photo.texture = load("res://DIALOGUES/dialogue_photos/" + character + ".png")
	if not dialogue_photo.texture:
		push_error("Dialogue photo for character '", character, "' not found at path: res://DIALOGUES/dialogue_photos/" + character + ".png")
	

func on_actual_line_change():
	pass
