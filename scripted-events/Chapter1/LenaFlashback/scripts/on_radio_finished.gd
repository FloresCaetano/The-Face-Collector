extends Node

@onready var radio: Radio = $".."
@onready var flashback_manager : LenaFirstFlashback = $"../.."

func _ready() -> void:
	radio.radio_finished.connect(_on_radio_finished)

func _on_radio_finished() -> void:
	GAMESTATE.register_event("lena_hears_radio")
	var interactable_planks =  load(flashback_manager.related_scenes.interactable_planks).instantiate()
	flashback_manager.add_child(interactable_planks)
