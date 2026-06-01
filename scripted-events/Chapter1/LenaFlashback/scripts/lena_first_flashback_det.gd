extends Node


func flashback_ends():
	PATHS.fade_controller.fade_in(2.0)
	await PATHS.fade_controller.fade_in_finished
	$"..".dialogue_finished.connect(func(): PATHS.scene_manager.end_flashback())
	
