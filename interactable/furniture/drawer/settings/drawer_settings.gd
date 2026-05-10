class_name DrawerSettings
extends Resource

@export var direction : Vector3 = Vector3.ZERO
@export var time : float = 0.7
@export var locked := false

@export var locked_sound : AudioStream = load("uid://r6lqlek1smat")
@export var open_sound : AudioStream = load("uid://cee3h4t812g00")
@export var close_sound : AudioStream = load("uid://lfeaevcmm06a")
