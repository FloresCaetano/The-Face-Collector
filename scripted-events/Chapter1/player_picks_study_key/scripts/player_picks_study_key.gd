class_name SeventPlayerPicksStudyKey
extends Node3D

@onready var key: Key = $Key
@onready var lights: SmartLight = $"../../../FullHouse/Lights/StudyLights/CeilingLamp/Lights"
@onready var breathing: AudioStreamPlayer3D = $Breathing
@onready var door_16: Door = %Door16

@onready var study_window: InteractionTrigger = $StudyWindow

func _ready() -> void:
	key.interacted.connect(_on_key_interacted)

func _on_key_interacted() -> void:
	lights.explode()
	breathing.stop()
	door_16.is_locked = false
	$ATOpenDoor.monitoring = true
	await get_tree().create_timer(0.1).timeout
	$Coleccionista.visible = true
	$StudyWindow.active = false
