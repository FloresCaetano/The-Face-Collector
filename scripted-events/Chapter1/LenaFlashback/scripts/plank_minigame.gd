extends Interactable

@export var placing_planks_stream : AudioStream
@onready var meshes: Node3D = $Meshes
@onready var fade_controller : FadeController = PATHS.fade_controller


func _ready() -> void:
	meshes.visible = false

func mouse_interaction() -> void:
	player.desactivate()
	var audio_stream_player_3d : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	add_child(audio_stream_player_3d)
	audio_stream_player_3d.stream = placing_planks_stream
	
	fade_controller.fade_in(0.6)
	await fade_controller.fade_in_finished
	
	meshes.visible = true
	active = false
	
	audio_stream_player_3d.play()
	await audio_stream_player_3d.finished
	
	fade_controller.fade_out(0.6)
	active = false
	leave_interaction()
	interacted.emit()

func on_leave_interaction() -> void:
	player.activate()

func on_mouse_exited() -> void:
	pass
