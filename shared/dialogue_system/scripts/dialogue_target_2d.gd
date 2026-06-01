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
	audio_stream_player.play()
