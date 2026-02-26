class_name PhotoFrameInspectable
extends Node3D

@export_category("Configuration")
@export var photo_item : Item

@export_category("dependencies")
@export var animations_player : AnimationPlayer
@onready var inventory : Inventory = PATHS.inventory


var unlocks_opened = 0

func check_if_al_locks_opened():
	if unlocks_opened == 4:
		#TODO: Reproducir sonido de hoja
		animations_player.play("back_cover_open")
		animations_player.connect("animation_finished", func(_anim):
			inventory.add_item(photo_item)
			inventory.remove_item_by_tag("photo_frame")
		)
		

func _on_lock_1_mouse_interact() -> void:
	animations_player.play("unlock_1")
	unlocks_opened += 1
	check_if_al_locks_opened()


func _on_lock_2_mouse_interact() -> void:
	animations_player.play("unlock_0")
	unlocks_opened += 1
	check_if_al_locks_opened()


func _on_lock_3_mouse_interact() -> void:
	animations_player.play("unlock_2")
	unlocks_opened += 1
	check_if_al_locks_opened()


func _on_lock_4_mouse_interact() -> void:
	animations_player.play("unlock_3")
	unlocks_opened += 1
	check_if_al_locks_opened()
