class_name SideStepArea
extends Node3D

@onready var player : Player = PATHS.player
@onready var p_rcam : PlayerRealCamera = PATHS.player_real_camera

@export var step_size : float = 0.5
const step_duration : float = 0.5

@onready var path_3d: Path3D = $Path3D
@onready var pathf_3d: PathFollow3D = $Path3D/PathFollow3D
@onready var start: Marker3D = $Start
@onready var end: Marker3D = $End
@onready var side_pcam: PhantomCamera3D = $Path3D/PathFollow3D/PhantomCamera3D
@onready var footsteps: FootstepsPlayer = $Path3D/PathFollow3D/PhantomCamera3D/Footsteps

var walk_direction : int = 0
@onready var timer : Timer
@onready var tween : Tween

#BOBBING
var bobbing_amount = -0.03  # Amplitude
var bobbing_speed = 6.0    # Frecuency
var bobbing_timer = 0.0
var base_camera_position = Vector3.ZERO

func _ready() -> void:
	set_process_input(false)
	footsteps.set_process(false)
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	

func enter_sidestep(direction : int):
	player.desactivate()
	p_rcam.change_state(p_rcam.State.BLOQUED)
	side_pcam.priority = 20
	pathf_3d.progress_ratio = 0.0 if direction == 0 else 1.0
	
	set_process_input(true)
	
func _input(_event: InputEvent) -> void:
	if tween and tween.is_running():
		return
	
	if Input.is_action_just_released("m_right") or Input.is_action_just_released("m_left"):
		timer.stop()
		walk_direction = 0
	
	if not timer.is_stopped():
		return
	
	if Input.is_action_pressed("m_right"):
		timer.start()
		walk_direction = 1
	elif Input.is_action_pressed("m_left"):
		timer.start()
		walk_direction = -1

		

func _process(delta: float) -> void:
	bobbing(delta)

func _on_timer_timeout() -> void:
	var new_progress : float = clampf(pathf_3d.progress + (walk_direction * step_size), 0.0, path_3d.curve.get_baked_length())
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(pathf_3d, "progress", new_progress, step_duration)
	footsteps._play_footstep()
	
	await tween.finished
	if pathf_3d.progress_ratio == 0.0 or pathf_3d.progress_ratio == 1.0:
		exit_sidestep()

func exit_sidestep():
	set_process_input(false)
	var progress_r = pathf_3d.progress_ratio
	side_pcam.priority = 0
	
	player.velocity = Vector3.ZERO
	
	await get_tree().physics_frame
	if progress_r < 0.5:
		player.global_position = start.global_position
	else:
		player.global_position = end.global_position
	p_rcam.change_state(p_rcam.State.IDLE)
	player.activate()

#BOBBING
func set_camera_rotation_z(value : float):
	side_pcam.rotation_degrees.z = value

func bobbing(delta):
	if tween and tween.is_running():
		bobbing_timer += delta * bobbing_speed
		var bob_offset = sin(bobbing_timer) * bobbing_amount
		side_pcam.position.y = base_camera_position.y + bob_offset
	else:
		# Volver a posición original si no hay movimiento
		side_pcam.position.y = lerp(side_pcam.position.y, base_camera_position.y, delta * 10)
		bobbing_timer = 0.0  # Opcional: resetear para evitar saltos bruscos
