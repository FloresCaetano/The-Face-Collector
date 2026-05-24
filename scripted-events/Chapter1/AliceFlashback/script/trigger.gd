extends Area3D
@onready var fp_animation_manager: AnimationManager = $FpAnimationManager

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		fp_animation_manager.start_animation("pick_up_note")
		await $FpAnimationManager/pick_up_note/Camera/PhantomCamera3D.tween_completed
		$"FpAnimationManager/pick_up_note/Brazos Harry".visible = true
		await fp_animation_manager.animation_finished
		PATHS.scene_manager.instantiate_flashsback("uid://dcdjcgt0q7gai")
		await PATHS.scene_manager.flashback_transition_ends
		$"..".queue_free()
