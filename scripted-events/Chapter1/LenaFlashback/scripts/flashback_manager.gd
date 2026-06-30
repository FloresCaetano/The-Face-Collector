class_name LenaFirstFlashback
extends Node3D

@onready var scene_manager : SceneManager = PATHS.scene_manager
@onready var dialogue_reader: DialogueReader = $DialogueReader
@onready var fade_controller : FadeController = PATHS.fade_controller

var related_scenes = {
	"interactable_planks" : "uid://clbm7fhjokltj",
	"after_window_boarding" : "uid://bffxr5cvsq317"
}

func _ready() -> void:
	if scene_manager:
		await scene_manager.flashback_transition_ends
	else:
		await get_tree().process_frame
	PATHS.player.desactivate()
	dialogue_reader.start()
