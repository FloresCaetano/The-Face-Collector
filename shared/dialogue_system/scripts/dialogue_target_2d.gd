class_name DialogueTarget2D
extends DialogueTarget

func select():
	is_selected = true
	label.text = ""

func deselect():
	is_selected = false
	label.text = ""

func next_token():
	label.visible_characters += 1
	var pitch : float = randf_range(pitch_range[0].to_float(), pitch_range[1].to_float())
	audio_stream_player.pitch_scale = pitch
	audio_stream_player.play()
