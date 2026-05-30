extends AnimationTree

@onready var a_state_machine : AnimationNodeStateMachinePlayback = get("parameters/playback")

#FLAGS
var is_on := true

var num_to_anim = {
	0 : "draw",
	1 : "play"
}

func _ready() -> void:
	next()

func next() -> void:
	if is_on:
		if randi_range(0, 100) < 93:
			a_state_machine.travel("draw")
		else:
			a_state_machine.travel("play")
		
	else:
		a_state_machine.travel("End")

func _on_animation_finished(_anim_name: StringName) -> void:
	next()
