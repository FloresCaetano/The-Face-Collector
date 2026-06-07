extends Node3D

func _ready() -> void:
	PATHS.get_door("6").close()
	PATHS.get_door("7").close()
	PATHS.get_door("6").is_locked = true
	PATHS.get_door("7").is_locked = true

func _on_look_at_trigger_1_entered_view() -> void:
	$LookAtTrigger1.is_active = false
	$LookAtTrigger2.is_active = true


func _on_look_at_trigger_2_entered_view() -> void:
	PATHS.get_door("12").open()
	$LookAtTrigger2.is_active = false
	PATHS.audio_controller.start_layer("phase5")


func _on_area_3d_body_entered(body: Node3D) -> void:
	PATHS.get_door("12").close()
	PATHS.get_door("14").open()
	PATHS.get_door("14").is_locked = false
	PATHS.audio_controller.start_layer("drums")
