class_name Door
extends Interactable


@export var object: Node3D

@export_category("Obstacle Settings")
@export var obstacle_check : Interactable
@export var invert_lock_state : bool = false

@export var settings : DoorSettings

@onready var inventory : Inventory = PATHS.inventory

var audio_stream_player_3d: AudioStreamPlayer3D

var is_open = false
var is_locked = false


func _ready() -> void:
	audio_stream_player_3d = AudioStreamPlayer3D.new()
	add_child(audio_stream_player_3d)

	if not object:
		object = self

func mouse_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		
		if settings.need_key:
			inventory.open()
			inventory.can_be_closed = false
			inventory.can_be_opened = false
			inventory.can_inspect_items = false

			await SIGNALBUS.item_selected
			var item = inventory.last_item_selected
			if item.name == settings.key_name:
				settings.need_key = false
				is_locked = false
				inventory.close()
			else:


				is_locked = true
				inventory.close()
			

		if is_locked:
			audio_stream_player_3d.stream = settings.locked_sound
			audio_stream_player_3d.play()
			await locked_anim()
			return
		
		if is_open:
			close()
		else:
			if obstacle_check: #CHECK IF THERE IS AN OBSTACLE THAN CAN PREVENT THE DOOR TO OPEN
				if invert_lock_state == not obstacle_check.is_open:
					open()
			else:
				open()

func on_mouse_exited() -> void:
	pass

func open() -> void:
	audio_stream_player_3d.stream = settings.open_sound
	audio_stream_player_3d.play()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", settings.open_angle, settings.open_speed).as_relative()

	collision_mask = 0 ; collision_layer = 0

	await tween.finished

	collision_mask = 0b1 ; collision_layer = 0b1
	is_open = true

func close() -> void:
	audio_stream_player_3d.stream = settings.close_sound
	audio_stream_player_3d.play()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", -settings.open_angle, settings.open_speed).as_relative()

	collision_mask = 0 ; collision_layer = 0

	await tween.finished

	collision_mask = 0b1 ; collision_layer = 0b1
	is_open = false



func locked_anim() -> void:
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", 10, 0.2).as_relative()
	await tween.finished

	tween.tween_property(object, "rotation_degrees:y", -10, 0.2).as_relative()
	await tween.finished