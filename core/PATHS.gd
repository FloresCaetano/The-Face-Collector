extends Node

var player_real_camera : PlayerRealCamera :
	get:
		return get_tree().get_first_node_in_group("real_camera")

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

var transition_controller : TransitionController :
	get:
		return get_tree().get_first_node_in_group("transition_controller")

var cassette_tape_player : CassetteTapePlayer :
	get:
		return get_tree().get_first_node_in_group("cassette_tape_player")
