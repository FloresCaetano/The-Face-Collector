class_name Door
extends Interactable


@export var object: Node3D

@export_category("Obstacle Settings")
@export var obstacle_check : Interactable
@export var invert_lock_state : bool = false

@export var settings : DoorSettings

var audio_stream_player_3d: AudioStreamPlayer3D

var is_open = false
@export var is_locked := false

signal door_interacted

func _ready() -> void:
	set_process_input(false)

	audio_stream_player_3d = AudioStreamPlayer3D.new()
	add_child(audio_stream_player_3d)

	if not object:
		object = self

func _on_item_selected(item : Item) -> void:
	if item is not KeyResource or item.key_id != settings.key_id:
		is_locked = true #TODO: MAKE A "THIS IS NOT THE RIGHT ITEM" ANIMATION OR SOMETHING
		locked_anim()
	else:
		settings.need_key = false
		is_locked = false

		stop_interacting()
		open()
		#TODO : MAKE A "YOU UNLOCKED THE DOOR" ANIMATION OR SOMETHING

func mouse_interaction() -> void:
	set_process_input(true)
	is_interacting = true
	if settings.need_key:
		inventory.open()
		inventory.can_be_closed = false
		inventory.can_be_opened = false
		inventory.can_inspect_items = false

		SIGNALBUS.item_selected.connect(_on_item_selected)
		return

	if is_locked:
		await locked_anim()
		stop_interacting()
		return
	
	if is_open:
		close()
	elif not obstacle_check or invert_lock_state == not obstacle_check.is_open:
		open()
	
	is_interacting = false


func _input(_event):
	if Input.is_action_just_pressed("scape") and is_interacting:
		stop_interacting()
	

func stop_interacting() -> void:
	is_interacting = false
	inventory.reset_vars()
	set_process_input(false)
	inventory.close()
	SIGNALBUS.item_selected.disconnect(_on_item_selected)

func on_mouse_exited() -> void:
	pass

func open() -> void:
	audio_stream_player_3d.stream = settings.open_sound
	audio_stream_player_3d.play()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", settings.open_angle, settings.open_speed).as_relative()

	collision_mask = 0 ; collision_layer = 0

	await tween.finished

	door_interacted.emit()
	
	collision_mask = 0b1 ; collision_layer = 0b1
	is_open = true
	is_interacting = false

func close() -> void:
	audio_stream_player_3d.stream = settings.close_sound
	audio_stream_player_3d.play()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", -settings.open_angle, settings.open_speed).as_relative()

	collision_mask = 0 ; collision_layer = 0

	await tween.finished
	
	door_interacted.emit()
	
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
