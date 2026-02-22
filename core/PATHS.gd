extends Node

var camera : Camera3D :
	get:
		return get_tree().get_first_node_in_group("camera")

var inventory : Inventory :
	get:
		return get_tree().get_first_node_in_group("inventory")
	
var mouse_raycast : MouseRayCast :
	get:
		return get_tree().get_first_node_in_group("mouse_raycast")

var player : Player :
	get:
		return get_tree().get_first_node_in_group("player")