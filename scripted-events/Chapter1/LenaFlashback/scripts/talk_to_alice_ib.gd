extends EventBehavior

@export var dialogue_reader: DialogueReader
@export var phantom_camera_3d: PhantomCamera3D
@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var fade_controller : FadeController = PATHS.fade_controller
@export var alice_animation_tree: AliceAnimationTree
@export var alice_animation_player: AnimationPlayer


func execute() -> void:
	if PATHS.inventory.has_item("food_can_opened") < 2:
		GAMEMANAGER.bark_dialogue("bark_lena_first_flashback", [1, 2])
		event_finished.emit()
		return
	
	#Fade In
	PATHS.player.desactivate()
	await player_rcam.change_state(player_rcam.State.BLOQUED)
	fade_controller.fade_in(0.8)
	await fade_controller.fade_in_finished
	
	#On Black Screen
	$"../../supply_crate_1_1_002".visible = true
	$"../../supply_crate_1_1_003".visible = true
	
	alice_animation_tree.is_on = false
	alice_animation_tree.active = false
	alice_animation_player.play("rest")
	
	phantom_camera_3d.priority = 20
	await phantom_camera_3d.tween_completed
	
	#Fade Out
	fade_controller.fade_out(0.8)
	
	
	dialogue_reader.start()
