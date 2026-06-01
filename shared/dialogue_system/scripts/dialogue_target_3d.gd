class_name DialogueTarget3D
extends DialogueTarget


@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D

var visible_ratio_equivalent_step

func on_actual_line_change():
	var parsed_text_lenght : float = label._text_2d.get_parsed_text().length()
	visible_ratio_equivalent_step = 1 / parsed_text_lenght

func select():
	
	PATHS.player.desactivate()
	await PATHS.player_real_camera.change_state(PATHS.player_real_camera.State.BLOQUED)
	label.text = ""
	phantom_camera_3d.priority = 20
	await phantom_camera_3d.tween_completed

func deselect():
	label.text = ""
	phantom_camera_3d.priority = 0
	await PATHS.player_real_camera.active_camera.tween_completed
	PATHS.player.activate()
	await PATHS.player_real_camera.change_state(PATHS.player_real_camera.State.IDLE)

func next_token():
	label.visible_ratio += visible_ratio_equivalent_step
	audio_stream_player.play()
	
	
