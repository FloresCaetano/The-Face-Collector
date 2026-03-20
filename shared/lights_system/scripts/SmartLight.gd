class_name SmartLight
extends Light3D

@export var blink_delay_min : float = 10
@export var blink_delay_max : float = 30
@export var random_blink : bool = false
@export var AUDIO_MAX_DISTANCE : float = 20.0
@export var blink_sound : AudioStream
@export var explode_sound : AudioStream

var audio_player : AudioStreamPlayer3D
var timer : Timer
var can_blink_timer : Timer
var default_energy : float
var is_exploded : bool = false


#FLAGS
var can_blink : bool = false

signal blink_finished

func _ready() -> void:
	default_energy = light_energy
	audio_player = AudioStreamPlayer3D.new()
	audio_player.max_distance = AUDIO_MAX_DISTANCE
	audio_player.stream = blink_sound
	add_child(audio_player)

	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)

	can_blink_timer = Timer.new()
	can_blink_timer.one_shot = false
	add_child(can_blink_timer)
	can_blink_timer.start(randf_range(blink_delay_min, blink_delay_max))

	can_blink_timer.timeout.connect(func():
		can_blink = true
		random_blink = true
		)

func random_blinking():
	if is_exploded:
		return

	if can_blink:
		blink()
		can_blink = false


func blink():
	if is_exploded:
		return

	audio_player.play()
	timer.start(0.801)
	await timer.timeout
	blink_finished.emit()

func check_timer_time():
	if is_exploded:
		light_energy = 0.0
		return

	if timer.time_left < 0.2:
		light_energy = default_energy
	elif timer.time_left < 0.704:
		light_energy = 0.0

func explode():
	if is_exploded:
		return

	can_blink_timer.stop()
	random_blink = false
	can_blink = false
	timer.stop()
	await blink()
	is_exploded = true
	audio_player.stream = explode_sound
	audio_player.play()
	light_energy = 0.0

func _process(_delta: float) -> void:
	if is_exploded:
		light_energy = 0.0
		return

	if !timer.is_stopped():
		check_timer_time()
	if random_blink:
		random_blinking()
	
