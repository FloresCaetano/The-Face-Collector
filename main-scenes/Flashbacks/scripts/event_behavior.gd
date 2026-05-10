extends EventBehavior

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func execute() -> void:
	if not PATHS.inventory.has_item("food_can"):
		GAMEMANAGER.bark_dialogue("bark_alice_first_flashback", [1, 1])
		event_finished.emit()
		return
	
	PATHS.inventory.remove_item_by_tag("food_can")
	PATHS.inventory.add_item(load("uid://dibc2oux5fyei")) #Opened Tomatoe Soup
	audio_stream_player_3d.play()
	event_finished.emit()

func on_interaction_end() -> void:
	pass
