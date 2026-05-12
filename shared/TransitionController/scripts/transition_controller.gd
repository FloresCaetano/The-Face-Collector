class_name TransitionController
extends Control

@export var black_screen : ColorRect

func fade_in(duration : float) -> void:
	black_screen.modulate.a = 1.0
	black_screen.visible = true
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(black_screen, "modulate:a", 0.0, duration)
	await tween.finished
	black_screen.visible = false

func fade_out(duration : float) -> void:
	black_screen.modulate.a = 0.0
	black_screen.visible = true
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(black_screen, "modulate:a", 1.0, duration)
	await tween.finished
