extends Interactable

signal mouse_interact

func mouse_interaction():
	if Input.is_action_just_pressed("select_item"):
		mouse_interact.emit()
		self.queue_free()

func on_mouse_exited():
	pass