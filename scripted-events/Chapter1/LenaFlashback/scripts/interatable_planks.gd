extends Node3D

var interacted_planks_count := 0

func _on_plank_interacted():
	interacted_planks_count += 1
	if interacted_planks_count == 4:
		GAMESTATE.register_event("lena_boards_the_windows")
	
