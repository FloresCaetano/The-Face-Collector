extends Interactable

@export var settings : DrawerSettings
@export var drawer_mesh : MeshInstance3D

var audio_stream_player_3d : AudioStreamPlayer3D

var is_open := false
var object : Node3D

func mouse_interaction() -> void:
	if settings.locked:
		locked_anim()
		return
	
	if is_open:
		close()
	else:
		open()
	

func open():
	is_open = true
	
	audio_stream_player_3d.stream = settings.open_sound
	audio_stream_player_3d.play()
	
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, 
	"global_position", settings.direction, settings.time).as_relative()
	
	await tween.finished
	interacted.emit()

func close():
	is_open = false
	
	audio_stream_player_3d.stream = settings.close_sound
	audio_stream_player_3d.play()
	
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, 
	"global_position", -settings.direction, settings.time).as_relative()
	
	await tween.finished
	interacted.emit()

func locked_anim() -> void:
	audio_stream_player_3d.stream = settings.locked_sound
	audio_stream_player_3d.play()

	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "rotation_degrees:y", 2, 0.1).as_relative()
	await tween.finished

	var tween2 : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween2.tween_property(object, "rotation_degrees:y", -2, 0.1).as_relative()
	await tween2.finished
	
	interacted.emit()

func _ready() -> void:
	audio_stream_player_3d = AudioStreamPlayer3D.new()
	add_child(audio_stream_player_3d)
	
	interacted.connect(_on_interact)
	
	object = drawer_mesh
	if not drawer_mesh:
		object = self



func _on_interact() -> void:
	is_interacting = false


func on_mouse_exited() -> void: pass
func _input(_event: InputEvent) -> void: pass
