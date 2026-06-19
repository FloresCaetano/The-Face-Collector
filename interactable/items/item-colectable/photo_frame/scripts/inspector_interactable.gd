extends Interactable

signal mouse_interact

func mouse_interaction():
		mouse_interact.emit()
		self.queue_free()

func on_mouse_exited():
	pass
