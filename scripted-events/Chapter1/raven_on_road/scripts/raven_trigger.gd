extends EventTrigger

@export var animation_player : AnimationPlayer


func _on_event_triggered():
	animation_player.play("fly_in")
