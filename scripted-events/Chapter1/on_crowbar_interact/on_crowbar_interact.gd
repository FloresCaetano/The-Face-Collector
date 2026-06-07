extends Node

@export var crowbar: Crowbar

func _ready() -> void:
	crowbar.interacted.connect(_on_crowbar_interacted)

func _on_crowbar_interacted() -> void:
	GAMESTATE.register_event("player_picks_crowbar")
