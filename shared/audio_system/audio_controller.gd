class_name AudioController
extends Node3D

@export var background_player : AudioStreamPlayer
@export var simple_player : AudioStreamPlayer
@export var left_back_player : AudioStreamPlayer3D
@export var right_back_player : AudioStreamPlayer3D
@onready var sync_stream : AudioStreamSynchronized = background_player.stream as AudioStreamSynchronized

var _selected_tracks : Array[AudioStream] = []

func get_selected_tracks() -> Array[AudioStream]:
	return _selected_tracks

func set_selected_tracks(tracks : Array[AudioStream]) -> void:
	_selected_tracks = tracks
	sync_stream.stream_count = _selected_tracks.size()

func reproduce_layer_at(index : int):
	var track = _selected_tracks[index]
	sync_stream.set_stream(index, track)
	sync_stream.set_sync_stream_volume(index, linear_to_db(0.0))
	_interpolate_volume_at(index, linear_to_db(1.0), 0.5)

func stop_layer_at(index : int):
	_interpolate_volume_at(index, linear_to_db(0.0), 0.5)
	await interpolation_finished
	sync_stream.set_stream(index, null)

signal interpolation_finished(index : int)
func _interpolate_volume_at(index : int, target_db : float, duration : float) -> void:
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(
		sync_stream.set_sync_stream_volume.bind(index), 
		sync_stream.get_sync_stream_volume(index),
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