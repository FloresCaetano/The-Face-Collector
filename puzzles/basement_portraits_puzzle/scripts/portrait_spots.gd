extends Node3D

@export var hanged_portrait_ev : Array[EventBehavior]

func _process(_delta: float) -> void:
	for ev in hanged_portrait_ev:
		if not ev.is_portrait_well_placed:
			return
	
	GAMESTATE.register_event("basement_portraits_solved")
	set_process(false)
