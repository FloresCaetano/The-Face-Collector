class_name CassetteTapePlayer
extends Interactable

@export var audio_stream_player : AudioStreamPlayer3D
@export var lbl_subtitles: Label
@export var lbl_subtitles_3d: Label3D
@export var camera_reference : PhantomCamera3D
@export var cassette_tape_player_interface: CassetteTapePlayerInterface
@export var tape_linear_container: TapeLinearContainer

@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera

signal flashback_ends(uid : String)
func _on_flashback_ends(uid : String):
	player.activate()
	can_leave = true
	flashback_ends.emit(uid)

func _ready() -> void:
	set_process_input(false)
	if PATHS.scene_manager:
		PATHS.scene_manager.flashback_ends.connect(_on_flashback_ends)
	

func mouse_interaction() -> void:
		player.desactivate()
		player_rcam.change_state(player_rcam.State.BLOQUED)
		
		await cassette_tape_player_interface.enter_cassette_tape_view()
		tape_linear_container.tape_selected.connect(_on_tape_selected)
		
		camera_reference.priority = 15 #Between player real camera and phantom camera of cassette tape player interface
		await camera_reference.tween_completed
		

func on_leave_interaction() -> void:
		camera_reference.priority = 0
		tape_linear_container.tape_selected.disconnect(_on_tape_selected)
		await cassette_tape_player_interface.leave_cassette_tape_view()

func on_mouse_exited() -> void:
	pass

func _on_start_transition():
	pass

func _on_tape_selected(tape : TapeResource) -> void:
	can_leave = false
	
	cassette_tape_player_interface.anim_tape_selected()
	await cassette_tape_player_interface.insert_cassette_finished
	PATHS.scene_manager.instantiate_flashsback(tape.flashback)
