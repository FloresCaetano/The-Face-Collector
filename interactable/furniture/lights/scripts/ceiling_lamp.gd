class_name CeilingLamp
extends Node3D

@export var is_on := true

@export_category("dependencies")
@export var on_model : MeshInstance3D
@export var off_model : MeshInstance3D
@export var lights: Array[Light3D]

func _ready():
	if is_on:
		turn_on()
	else:
		turn_off()

func turn_on():
	on_model.visible = true
	off_model.visible = false
	is_on = true
	for light in lights:
		light.visible = true
	

func turn_off():
	on_model.visible = false
	off_model.visible = true
	is_on = false
	for light in lights:
		light.visible = false
