extends Interactable

@export var animation_player: AnimationPlayer
@export var food_can_opened: Item

func mouse_interaction() -> void:
	if not inventory.has_item("food_can"):
		GAMEMANAGER.bark_dialogue("bark_lena_first_flashback", [0,0])
		return
	
	animation_player.play("open_can")
	inventory.remove_item_by_tag("food_can")
	await animation_player.animation_finished
	inventory.add_item(food_can_opened)
	leave_interaction()

func on_mouse_exited() -> void:
	pass
