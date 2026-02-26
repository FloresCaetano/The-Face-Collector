class_name FirstAudioLoopController
extends Node

@export var cassete_tape_player : CassetteTapePlayer
@export var tape : TapeResource

@onready var inventory : Inventory = PATHS.inventory

var can_repeat_tape : bool = true
func _ready() -> void:
	repeat_tape()
	
func repeat_tape() -> void:
	cassete_tape_player.play_tape(tape, false)
	await cassete_tape_player.tape_finished
	if can_repeat_tape:
		repeat_tape()

func _process(_delta):
	if cassete_tape_player.is_interacting:
		can_repeat_tape = false
		inventory.add_item(tape)
		queue_free()
