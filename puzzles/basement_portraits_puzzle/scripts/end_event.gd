extends Node3D

@onready var audio_controller : AudioController = PATHS.audio_controller
@export var suspence_ambience_sound : LabeledTrack

@export var screams: AudioStreamPlayer3D
@export var wood_crash: AudioStreamPlayer3D
@export var soft_knocks: AudioStreamPlayer3D
@export var look_at_trigger: VisibilityTrigger


func _ready() -> void:
	check_event()

func check_event() -> void:
	if not GAMESTATE.is_event_registered("basement_portraits_solved"):
		get_tree().create_timer(3.0).timeout.connect(check_event)
		return
	
	start_event()

func start_event() -> void:
	audio_controller.append_selected_track(suspence_ambience_sound)
	screams.play()
	await screams.finished
	look_at_trigger.is_active = true
	start_wood_knocks()

func start_wood_knocks():
	soft_knocks.play()
	await soft_knocks.finished
	start_wood_knocks()

func _on_look_at_trigger_entered_view() -> void:
	pass # Replace with function body.
