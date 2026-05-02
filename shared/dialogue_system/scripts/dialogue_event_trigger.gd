extends Node
@export var marker_3d: Marker3D

func camera_looks_to_transom():
	var rcam : PlayerRealCamera = PATHS.player_real_camera
	rcam.look_at_target(marker_3d, 1.0, 2.0)
	
