class_name FadeController
extends Control

@export var blackbox: ColorRect
@export var blur: ColorRect

signal fade_in_finished
func fade_in(duration: float = 1.0) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(blackbox, "modulate:a", 1.0, duration)
	tween.tween_callback(func(): fade_in_finished.emit())
	

signal fade_out_finished
func fade_out(duration: float = 1.0) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(blackbox, "modulate:a", 0.0, duration)
	tween.tween_callback(func(): fade_out_finished.emit())

signal transition_finished
func transition(d_in: float = 1.0, wait_time: float = 1.0, d_out: float = 1.0) -> void:
	fade_in(d_in)
	await fade_in_finished
	
	await get_tree().create_timer(wait_time).timeout
	
	fade_out(d_out)
	await fade_out_finished
	
	transition_finished.emit()

func set_blur_ammount(ammount : float) -> void:
	var blur_material = blur.material as ShaderMaterial
	blur_material.set_shader_parameter("offset", ammount)

signal blur_in_finished
func blur_in(duration: float = 1.0) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_method(set_blur_ammount, 0.0, 18, duration)
	tween.tween_callback(func(): blur_in_finished.emit())
	
signal blur_out_finished
func blur_out(duration: float = 1.0) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_method(set_blur_ammount, 18, 0.0, duration)
	tween.tween_callback(func(): blur_out_finished.emit())
