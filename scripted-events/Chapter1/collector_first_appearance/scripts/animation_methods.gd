extends Node
@onready var audio_controller : AudioController = PATHS.audio_controller

@export_category("Electric Light Error Configs")
@export var noise: FastNoiseLite
@export var base_energy: float = 1.0
@export var flicker_speed: float = 2.0
@export var drop_threshold: float = -0.4
@export var light: SmartLight
@export var audio_stream_player_3d: AudioStreamPlayer3D
@export var layers : Array[LabeledTrack]


var can_flicker := false

var time_passed: float = 0.0

func light_flickering(delta):
	time_passed += delta * flicker_speed
	
	var noise_val: float = noise.get_noise_1d(time_passed * 100.0)
	
	if noise_val < drop_threshold:
		light.light_energy = 0.0
	else:
		var normalized_noise: float = inverse_lerp(drop_threshold, 1.0, noise_val)
		light.light_energy = lerp(0.1, base_energy, normalized_noise)

func set_drop_threshold(threshold : float):
	drop_threshold = threshold

func start_flickering():
	audio_stream_player_3d.play()
	can_flicker = true

func stop_flickering():
	can_flicker = false
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(light, "light_energy", 1.0, 0.8)
	tween.tween_property(audio_stream_player_3d, "volume_linear", 0.0, 0.8)
	$"../../../../../../FullHouse/Lights".visible = false
	$"../../../../../../PlayerAndLight/SpotLight3D".visible = true
	$"../../../../../../PlayerAndLight/Player/OmniLight3D".visible = false
	audio_controller.set_selected_tracks(layers)
	audio_controller.start_layer("phase1")
	audio_controller.start_layer("phase2")


func load_and_start_layers():
	pass

func _process(delta: float) -> void:
	if can_flicker:
		light_flickering(delta)
