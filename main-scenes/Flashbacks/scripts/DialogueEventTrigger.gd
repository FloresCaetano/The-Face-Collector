extends DialogueEventTrigger

@onready var inventory : Inventory = PATHS.inventory
@onready var fade_controller : FadeController = PATHS.fade_controller

func _ready() -> void:
	fade_controller.fade_in(0.0)

func flash_back_start():
	fade_controller.fade_out(1.0)

func player_pick_three_food_cans():
	while inventory.has_item("food_can") < 3:
		await get_tree().process_frame

func player_prepare_three_food_cans():
	while inventory.has_item("food_can_opened") < 3:
		await get_tree().process_frame
	
func alice_waits_on_table():
	await wait_for_event("alice_waits_on_table")

func alice_eating_alone():
	fade_controller.fade_out(1.0)
	await fade_controller.fade_out_finished

func flash_back_ends():
	PATHS.scene_manager.end_flashback()
