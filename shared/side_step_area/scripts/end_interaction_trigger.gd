extends EventBehavior

@export var side_step_area: SideStepArea

func execute() -> void:
	side_step_area.enter_sidestep(1)
	
