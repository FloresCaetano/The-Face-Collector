class_name FadeController
extends Control

signal fade_in_finished
func fade_in(duration: float = 1.0) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 1.0, duration)
	tween.tween_callback(func(): fade_in_finished.emit())
	

signal fade_out_finished
func fade_out(duration: float = 1.0) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(func(): fade_out_finished.emit())

signal transition_finished
func transition(d_in: float = 1.0, wait_time: float = 1.0, d_out: float = 1.0) -> void:
	fade_in(d_in)
	await fade_in_finished
	
	await get_tree().create_timer(wait_time).timeout
	
	fade_out(d_out)
	await fade_out_finished
	
	transition_finished.emit()
