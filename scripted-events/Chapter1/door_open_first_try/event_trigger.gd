extends Node

func _ready() -> void:
	%Door.door_interacted.connect(func(): 
		$"../DialogueReader".start()
		)
