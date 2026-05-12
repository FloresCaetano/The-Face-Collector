extends Node

var player_real_camera : PlayerRealCamera :
	get:
		return get_tree().get_first_node_in_group("real_camera")

var main_pcamera : PhantomCamera3D :
	get:
		return get_tree().get_first_node_in_group("main_pcamera")

var inventory : Inventory :
	get:
		return get_tree().get_first_node_in_group("inventory")
	
var mouse_raycast : MouseRayCast :
	get:
		return get_tree().get_first_node_in_group("mouse_raycast")

var player : Player :
	get:
		return get_tree().get_first_node_in_group("player")
	
var audio_controller : AudioController :
	get:
		return get_tree().get_first_node_in_group("audio_controller")

var fade_controller : FadeController :
	get:
		return get_tree().get_first_node_in_group("fade_controller")

var cassette_tape_player : CassetteTapePlayer :
	get:
		return get_tree().get_first_node_in_group("cassette_tape_player")

var scene_manager : SceneManager :
	get:
		return get_tree().get_first_node_in_group("scene_manager")

var internal_voice : DialogueTarget2D:
	get:
		return get_tree().get_first_node_in_group("internal_voice")

var flashback_recording_voice : DialogueTarget2D:
	get:
		return get_tree().get_first_node_in_group("flashback_recording_voice")
