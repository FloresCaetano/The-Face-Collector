extends Path3D

@export var door: Door
@export var light : SmartLight

func _ready() -> void:
	pass

func open_door() -> void:
	door.open()

func close_door() -> void:
	door.close()

func locked_anim() -> void:
	door.locked_anim()

func light_explode() -> void:
	light.explode()