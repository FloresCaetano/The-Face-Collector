extends Node

func _on_door_interacted() -> void:
	GAMEMANAGER.bark_dialogue("bark_alice_first_flashback", [0, 0])
