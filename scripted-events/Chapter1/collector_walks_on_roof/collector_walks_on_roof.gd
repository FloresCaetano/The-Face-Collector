extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GAMESTATE.event_registered.connect(_on_event_registered)




func _on_event_registered(_current_chapter : String, event_id : String):
	if event_id == "player_picks_first_tape":
		$Trigger.monitoring = true


func _on_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		GAMESTATE.register_event("player_walks_on_roof")
		$Trigger.queue_free()
		$AnimationPlayer.play("walks")
		await $AnimationPlayer.animation_finished
		queue_free()
