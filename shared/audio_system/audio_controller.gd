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
			return {"index" : i, "stream" : track.stream}
	return {}

func start_layer(label : String):
	var track : Dictionary = get_track_by_label(label)
	if track.is_empty():
		push_error("NO SE PUDO INICIAR EL TRACK: " + label)
		return
		
	var stream : AudioStream = track.stream
	var index : int = track.index
	
	sync_stream.set_sync_stream(index, stream)
	sync_stream.set_sync_stream_volume(index, linear_to_db(0.0))
	_interpolate_volume_at(index, linear_to_db(1.0), 2.0)
	background_player.stream = sync_stream
	if not background_player.playing: background_player.play()

func stop_layer(label : String):
	var track : Dictionary = get_track_by_label(label)
	if track.is_empty():
		push_error("NO SE PUDO DETENER EL TRACK: " + label)
		return
		
	var index : int = track.index
	
	_interpolate_volume_at(index, linear_to_db(0.0), 0.5)
	await interpolation_finished
	sync_stream.set_stream(index, null)

signal interpolation_finished(index : int)
func _interpolate_volume_at(index : int, target_db : float, duration : float) -> void:
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	tween.tween_method(
		func(value): sync_stream.set_sync_stream_volume(index, value),
		linear_to_db(0.001),
		target_db,
		duration
	)
	tween.tween_callback(func(): interpolation_finished.emit(index))

func simple_play(stream : AudioStream) -> void:
	simple_player.stream = stream
	simple_player.play()

func left_simple_play(stream : AudioStream) -> void:
	left_back_player.stream = stream
	left_back_player.play()

func right_simple_play(stream : AudioStream) -> void:
	right_back_player.stream = stream
	right_back_player.play()
