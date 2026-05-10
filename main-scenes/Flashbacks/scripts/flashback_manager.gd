class_name AliceFirstFlashBackManager
extends Node3D

@onready var scene_manager : SceneManager = PATHS.scene_manager
@onready var dialogue_reader: DialogueReader = $DialogueReader

@export_category("Dependencies")
@export var food_can: FoodCan

func _ready():
	await get_tree().process_frame
	dialogue_reader.start()
