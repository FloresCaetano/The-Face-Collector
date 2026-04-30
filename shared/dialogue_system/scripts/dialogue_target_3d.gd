class_name DialogueTarget3D
extends DialogueTarget

@export var target_id: String

@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D
@onready var rich_text_3d: RichText3D = $PhantomCamera3D/RichText3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func select():
	rich_text_3d.text = ""
	phantom_camera_3d.priority = 20
	#await phantom_camera_3d.tween_completed

func deselect():
	rich_text_3d.text = ""
	phantom_camera_3d.priority = 0

func set_text(text : RefCounted):
	rich_text_3d.text += text.char
	audio_stream_player_3d.play()
