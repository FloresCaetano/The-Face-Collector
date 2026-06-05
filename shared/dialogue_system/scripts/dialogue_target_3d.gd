class_name DialogueTarget3D
extends DialogueTarget


@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D

var visible_ratio_equivalent_step

func on_actual_line_change():
	var parsed_text_lenght : float = label._text_2d.get_parsed_text().length()
	visible_ratio_equivalent_step = 1 / parsed_text_lenght

func select():
	is_selected = true
	label.text = ""
	phantom_camera_3d.priority = 30
	await phantom_camera_3d.tween_completed

func deselect():
	is_selected = false
	label.text = ""
	phantom_camera_3d.priority = 0

func next_token():
	label.visible_ratio += visible_ratio_equivalent_step
	var pitch : float = randf_range(pitch_range[0].to_float(), pitch_range[1].to_float())
	audio_stream_player.pitch_scale = pitch
	audio_stream_player.play()
	
	
