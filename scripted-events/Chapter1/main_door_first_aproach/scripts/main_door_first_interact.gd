extends Node3D

@onready var rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var player : Player = PATHS.player
@onready var dialogue_reader: DialogueReader = $DialogueReader
@onready var world_environment: WorldEnvironment = %WorldEnvironment
@onready var interior_env : Environment = preload("uid://dc6cxt4hxrydi")

@onready var audio_controller : AudioController = PATHS.audio_controller

func _ready() -> void:
	var doors : Array[Door] = [%Door, %Door2]
	for door in doors: door.door_interacted.connect(_on_door_interacted)

func _on_door_interacted():
	player.desactivate()
	await rcam.change_state(rcam.State.BLOQUED)
	dialogue_reader.start()
	dialogue_reader.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.activate()
	await rcam.change_state(rcam.State.IDLE)

func switch_enviroment():
	world_environment.environment = interior_env
	
	
func clear_rain():
	var rain: GPUParticles3D = $"../../../FullHouse/HouseExterior/Rain"
	rain.emitting = false
	audio_controller.stop_layer("rain1")
	audio_controller.append_selected_track(load("uid://bfqbbh1r5d70c"))
	audio_controller.start_layer("piano_ambience")
	$"../../../WorldEnvironment/ExteriorLight".visible = true
	
