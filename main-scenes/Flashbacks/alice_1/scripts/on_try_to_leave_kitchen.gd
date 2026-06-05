extends Node

func _ready() -> void:
	await get_tree().process_frame
	for i in range(6, 10): #from door 6 to door 9
		var door : Door = PATHS.get_door(str(i))
		if door.is_open:
			door.close(false)
		door.door_interacted.connect(_on_door_interacted)
		

func _on_door_interacted() -> void:
	GAMEMANAGER.bark_dialogue("bark_alice_first_flashback", [0, 0])
