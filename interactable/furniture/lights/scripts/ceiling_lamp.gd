class_name CeilingLamp
extends Node3D

@export var is_on := true

@export_category("dependencies")
@export var on_model : MeshInstance3D
@export var off_model : MeshInstance3D
@export var lights: Array[Light3D]
@export var random_blink : bool :
	set(value):
		random_blink = value
		set_random_blink(value)

func _ready():
	if is_on:
		turn_on()
	else:
		turn_off()

func turn_on():
	if on_model and off_model:
		on_model.visible = true
		off_model.visible = false
	is_on = true
	for light in lights:
		light.visible = true

func turn_off():
	if on_model and off_model:
		on_model.visible = false
		off_model.visible = true
	is_on = false
	for light in lights:
		light.visible = false

func set_random_blink(value : bool):
	for light in lights:
		if light is SmartLight:
			light.random_blink = value
