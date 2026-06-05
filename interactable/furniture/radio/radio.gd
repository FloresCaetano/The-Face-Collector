class_name Radio
extends Interactable

@export var dialogue_reader: DialogueReader

@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera

signal radio_finished
func mouse_interaction() -> void:
	player.desactivate()
	player_rcam.change_state(player_rcam.State.BLOQUED)
	dialogue_reader.start()

func on_mouse_exited() -> void:
	pass

func _on_dialogue_reader_dialogue_finished() -> void:
	player_rcam.change_state(player_rcam.State.IDLE)
	player.activate()
	leave_interaction()
	radio_finished.emit()
	
