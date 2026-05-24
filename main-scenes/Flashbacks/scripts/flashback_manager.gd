class_name AliceFirstFlashBackManager
extends Node3D

@onready var scene_manager : SceneManager = PATHS.scene_manager
@onready var dialogue_reader: DialogueReader = $DialogueReader


func _ready():
	await PATHS.scene_manager.flashback_transition_ends
	dialogue_reader.start()
