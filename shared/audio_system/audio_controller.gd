class_name AudioController
extends Node3D

@export var background_player : AudioStreamPlayer
@export var simple_player : AudioStreamPlayer
@export var left_back_player : AudioStreamPlayer3D
@export var right_back_player : AudioStreamPlayer3D
@onready var sync_stream : AudioStreamSynchronized = background_player.stream as AudioStreamSynchronized

var _selected_tracks : Array[LabeledTrack] = []

func get_selected_tracks() -> Array[LabeledTrack]:
	return _selected_tracks

func set_selected_tracks(tracks : Array[LabeledTrack]) -> void:
	_selected_tracks = tracks
	sync_stream.stream_count = _selected_tracks.size()

func append_selected_track(track : LabeledTrack) -> void:
	_selected_tracks.append(track)
	sync_stream.stream_count = _selected_tracks.size()
	sync_stream.set_sync_stream(_selected_tracks.size() - 1, track.stream)

func get_track_by_label(label : String) -> Dictionary:
	for i in range(_selected_tracks.size()):
		var track = _selected_tracks[i]
		if track.label == label:
			return {"index" : i, "stream" : track.stream, "volume" : track.volume_db}
	return {}

func start_layer(label : String):
	var track : Dictionary = get_track_by_label(label)
	if track.is_empty():
		push_error("NO SE PUDO INICIAR EL TRACK: " + label)
		return
		
	var stream : AudioStream = track.stream
	var index : int = track.index
	var volume : float = track.volume
	
	sync_stream.set_sync_stream(index, stream)
	sync_stream.set_sync_stream_volume(index, linear_to_db(0.0))
	_interpolate_volume_at(index, linear_to_db(0.001), volume, 2.0)
	background_player.stream = sync_stream
	if not background_player.playing: background_player.play()

func stop_layer(label : String):
	var track : Dictionary = get_track_by_label(label)
	if track.is_empty():
		push_error("NO SE PUDO DETENER EL TRACK: " + label)
		return
		
	var index : int = track.index
	
	_interpolate_volume_at(index, sync_stream.get_sync_stream_volume(index), linear_to_db(0.0), 10.0)
	await interpolation_finished
	sync_stream.set_sync_stream(index, null)

signal interpolation_finished(index : int)
func _interpolate_volume_at(index : int, from : float, to : float, duration : float) -> void:
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	to = clamp(to, linear_to_db(0.001), 0.0)
	from = clamp(from, linear_to_db(0.001), 0.0)
	tween.tween_method(
		func(value): sync_stream.set_sync_stream_volume(index, value),
		from,
		to,
		duration
	)
	tween.tween_callback(func(): interpolation_finished.emit(index))

signal simple_play_finished(stream)
func simple_play(stream : AudioStream) -> void:
	simple_player.stream = stream
	simple_player.play()
	simple_play_finished.emit(stream)

func left_simple_play(stream : AudioStream) -> void:
	left_back_player.stream = stream
	left_back_player.play()

func right_simple_play(stream : AudioStream) -> void:
	right_back_player.stream = stream
	right_back_player.play()

func fade_bus_volume(bus_name : String, target_db : float, duration : float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var tween = create_tween()
	tween.tween_method(
		func(value): AudioServer.set_bus_volume_db(bus_index, value),
		AudioServer.get_bus_volume_db(bus_index),
		target_db,
		duration
	)
	await tween.finished

var original_audio_volumes = {}
func stop_all_volumes_in_scene(scene : Node3D):
	var scene_node_volumes = {}
	for node in scene.find_children("*", "", true, false):
		if (node is AudioStreamPlayer) or (node is AudioStreamPlayer3D):
			scene_node_volumes[node] = node.volume_db
			node.volume_db = -80.0
	original_audio_volumes[scene] = scene_node_volumes

func restore_all_volumes_in_scene(scene : Node3D):
	for node in scene.find_children("*", "", true, false):
		if node is AudioStreamPlayer or node is AudioStreamPlayer3D:
			node.volume_db = original_audio_volumes[scene].get(node)
	original_audio_volumes.erase(scene)
