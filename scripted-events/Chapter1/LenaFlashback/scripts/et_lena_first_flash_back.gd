extends Node

@onready var player : Player = PATHS.player
@onready var main_pcamera : PhantomCamera3D = PATHS.main_pcamera
@onready var scene_manager : SceneManager = PATHS.scene_manager
@onready var fade_controller : FadeController = PATHS.fade_controller
@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var flashback_manager: LenaFirstFlashback = $"../.."


func _ready() -> void:
	fade_controller.fade_in(0.0)

func lena_wakes_up_and_hears_radio():
	await get_tree().create_timer(2.0).timeout
	fade_controller.fade_out(1.0)
	await fade_controller.fade_out_finished
	await get_tree().create_timer(2.0).timeout
	main_pcamera.tween_duration = 1.2
	$PhantomCamera3D.priority = 0
	await main_pcamera.tween_completed
	
	player.activate()
	await GAMESTATE.wait_for_event("lena_hears_radio")
	
func lena_boards_the_windows():
	await GAMESTATE.wait_for_event("lena_boards_the_windows")
	player.desactivate()
	player_rcam.change_state(player_rcam.State.BLOQUED)
	
	fade_controller.fade_in(1.0)
	await fade_controller.fade_in_finished
	player.position = Vector3(16.275, 2.087, -3.835) #Kitchen
	var after_window_boarding = load(flashback_manager.related_scenes.after_window_boarding).instantiate()
	flashback_manager.add_child(after_window_boarding)

func second_part_starts():
	fade_controller.fade_out(1.0)
	await fade_controller.fade_out_finished
	player.activate()
	player_rcam.change_state(player_rcam.State.IDLE)
	
func lena_ends_dialogue_with_alice():
	await GAMESTATE.wait_for_event("dialogue_with_alice_ends")

func flashback_ends():
	scene_manager.end_flashback()
