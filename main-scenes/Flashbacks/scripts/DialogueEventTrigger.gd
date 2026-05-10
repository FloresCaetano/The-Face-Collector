extends Node

@onready var inventory : Inventory = PATHS.inventory

func player_prepare_three_food_cans():
	while inventory.has_item("food_can_opened") < 3:
		await get_tree().process_frame

func alice_eating_alone_transition():
	pass
	
func flash_back_ends():
	pass
