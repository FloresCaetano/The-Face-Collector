class_name Camera
extends Camera3D

@onready var player = $"../.."
var is_transitioning : bool = false
var is_on_destiny : bool = false

signal finished_transition
signal return_to_original_finished

var tween : Tween
var temporal_camera : Camera3D

func _ready() -> void:
	PATHS.mouse_raycast.target = self

func transition(reference : Transform3D, duration : float = 2.0):
	player.desactivate()

	temporal_camera = self.duplicate() as Camera3D
	PATHS.mouse_raycast.target = temporal_camera
	temporal_camera.current = true
	temporal_camera.transform = transform
	get_parent().add_child(temporal_camera)
	is_transitioning = true

	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(temporal_camera, "global_transform", reference, duration)
	await tween.finished
	finished_transition.emit()
	is_transitioning = false
	is_on_destiny = true

	

func return_to_original_pos(duration : float = 2):
	if is_on_destiny:
		is_on_destiny = false
		tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(temporal_camera, "global_transform", self.global_transform, duration)
		await tween.finished
		temporal_camera.queue_free()

		player.activate()
		return_to_original_finished.emit()
		PATHS.mouse_raycast.target = self
