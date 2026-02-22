class_name Door
extends Interactable



@export var object: Node3D

@export_category("Door Settings")
@export var open_angle = 90.0
@export var open_speed = 1.2
@export var need_key = false
@export var key_name : String = ""

@export_category("Audio Settings")
@export var locked_sound : AudioStream = load("uid://r6lqlek1smat")
@export var open_sound : AudioStream = load("uid://ce52ef7u72i4x")
@export var close_sound : AudioStream = load("uid://dye38x4yih7v7")

@export_category("Obstacle Settings")
@export var obstacle_check : Interactable
@export var invert_lock_state : bool = false

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
		
		if need_key:
			inventory.open()
			inventory.can_be_closed = false
			inventory.can_be_opened = false
			inventory.can_inspect_items = false

			inventory.item_selected.connect(
				func(item : Item) -> void:
					if item.name == key_name:
						need_key = false
						is_locked = false
						inventory.close()
					else:
						is_locked = true
						inventory.close()
			)
			await inventory.item_selected


		if is_locked:
			audio_stream_player_3d.stream = locked_sound
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
	audio_stream_player_3d.stream = open_sound
	audio_stream_player_3d.play()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", open_angle, open_speed).as_relative()

	collision_mask = 0 ; collision_layer = 0

	await tween.finished

	collision_mask = 0b1 ; collision_layer = 0b1
	is_open = true

func close() -> void:
	audio_stream_player_3d.stream = close_sound
	audio_stream_player_3d.play()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", -open_angle, open_speed).as_relative()

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