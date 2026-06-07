extends Node3D
@onready var knoks: AudioStreamPlayer3D = $Knoks
@onready var breathing: AudioStreamPlayer3D = $Breathing


func _ready() -> void:
	GAMESTATE.event_registered.connect(_on_event_registered)

func _on_look_at_trigger_entered_view() -> void:
	breathing.play()
	knoks.play()
	$LookAtTrigger.queue_free()
	breathing.finished.connect(queue_free)

func _on_event_registered(_current_chapter : String, event_id : String) -> void:
	if event_id == "player_picks_crowbar":
		$LookAtTrigger.is_active = true
