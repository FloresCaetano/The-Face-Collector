extends Node


func dialogue_with_alice_ends():
	PATHS.fade_controller.fade_in(2.0)
	await PATHS.fade_controller.fade_in_finished
	GAMESTATE.register_event("dialogue_with_alice_ends")
	
