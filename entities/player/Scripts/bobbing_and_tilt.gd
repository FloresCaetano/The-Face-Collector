extends Node

@export var player: Player
@export var main_camera: PhantomCamera3D

#BOBBING
var bobbing_amount = 0.03  # Amplitude
var bobbing_speed = 6.0    # Frecuency
var bobbing_timer = 0.0
var base_camera_position = Vector3.ZERO

func _input(_event: InputEvent) -> void:
	camera_tilt(player.get_input().x)

func _process(delta: float) -> void:
	bobbing(delta)

func camera_tilt(input : int):
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(set_camera_rotation_z, main_camera.rotation_degrees.z, input, 0.4)

func set_camera_rotation_z(value : float):
	main_camera.rotation_degrees.z = value

func bobbing(delta):
	if player.velocity != Vector3.ZERO and player.is_on_floor():
		bobbing_timer += delta * bobbing_speed
		var bob_offset = sin(bobbing_timer) * bobbing_amount
		main_camera.position.y = base_camera_position.y + bob_offset
	else:
		# Volver a posición original si no hay movimiento
		main_camera.position.y = lerp(main_camera.position.y, base_camera_position.y, delta * 10)
		bobbing_timer = 0.0  # Opcional: resetear para evitar saltos bruscos
