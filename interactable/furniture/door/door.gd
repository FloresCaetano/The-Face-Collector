class_name Door
extends Interactable

@export var object: Node3D

@export_category("Obstacle Settings")
@export var obstacle_check : Interactable
@export var invert_lock_state : bool = false

@export var settings : DoorSettings
var default_locked_sound : AudioStream = load("uid://r6lqlek1smat")
var default_open_sound : AudioStream = load("uid://ce52ef7u72i4x")
var default_close_sound : AudioStream = load("uid://dye38x4yih7v7")

var audio_stream_player_3d: AudioStreamPlayer3D

var is_open = false
@export var is_locked := false

signal door_interacted

func _ready() -> void:
	if settings:
		if not settings.locked_sound: settings.locked_sound = default_locked_sound
		if not settings.open_sound: settings.open_sound = default_open_sound
		if not settings.close_sound: settings.close_sound = default_close_sound
	set_process_input(false)

	audio_stream_player_3d = AudioStreamPlayer3D.new()
	add_child(audio_stream_player_3d)

	if not object:
		object = self

func mouse_interaction() -> void:
	set_process_input(true)
	is_interacting = true
	if settings.need_key:
		if inventory.has_item(settings.key_id):
			settings.need_key = false
			open()
		else:
			await locked_anim()
		is_interacting = false
		leave_interaction()
		return

	if is_locked:
		await locked_anim()
		leave_interaction()
		return
	
	if is_open:
		close()
	elif not obstacle_check or invert_lock_state == not obstacle_check.is_open:
		open()
	
	leave_interaction()
	is_interacting = false

func on_leave_interaction() -> void:
	inventory.reset_vars()

func on_mouse_exited() -> void:
	pass

func open(sound := true) -> void:
	if is_open:
		return
	if sound:
		audio_stream_player_3d.stream = settings.open_sound
		audio_stream_player_3d.play()
		door_interacted.emit()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", settings.open_angle, settings.open_speed).as_relative()

	collision_mask = 0 ; collision_layer = 0

	await tween.finished

	
	
	collision_mask = 0b1 ; collision_layer = 0b1
	is_open = true
	is_interacting = false

func close(sound := true) -> void:
	if not is_open:
		return
	if sound:
		audio_stream_player_3d.stream = settings.close_sound
		audio_stream_player_3d.play()
		door_interacted.emit()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", -settings.open_angle, settings.open_speed).as_relative()

	collision_mask = 0 ; collision_layer = 0

	await tween.finished
	
	
	
	collision_mask = 0b1 ; collision_layer = 0b1
	is_open = false
	is_interacting = false



func locked_anim() -> void:
	audio_stream_player_3d.stream = settings.locked_sound
	audio_stream_player_3d.play()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", 2, 0.1).as_relative()
	await tween.finished

	var tween2 : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween2.tween_property(object, "rotation_degrees:y", -2, 0.1).as_relative()
	await tween2.finished
	door_interacted.emit()
