extends EventBehavior
@onready var fp_animation_manager: AnimationManager = $"../FpAnimationManager"

func execute() -> void:
	fp_animation_manager.start_animation("ClimbTravesign")
	fp_animation_manager.animation_finished.connect(func():
		$"../../..".queue_free()
		)
