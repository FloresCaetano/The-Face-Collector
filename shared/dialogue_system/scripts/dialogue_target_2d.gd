class_name DialogueTarget2D
extends DialogueTarget

var hide_target_tween : Tween

func select():
	if hide_target_tween and hide_target_tween.is_running(): hide_target_tween.stop()
	hide_target_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	hide_target_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	self.visible = true
	is_selected = true
	label.text = ""

func deselect():
	hide_target_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	hide_target_tween.tween_property(self, "modulate:a", 0.0, 0.4)
	hide_target_tween.tween_callback(func(): self.visible = false)
	is_selected = false

func next_token():
	label.visible_characters += 1
	var pitch : float = randf_range(pitch_range[0].to_float(), pitch_range[1].to_float())
	audio_stream_player.pitch_scale = pitch
	audio_stream_player.play()
