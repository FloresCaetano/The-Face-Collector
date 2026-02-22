class_name CassetteTapePlayer
extends Interactable

@export var audio_stream_player : AudioStreamPlayer3D
@export var lbl_subtitles: Label
@export var lbl_subtitles_3d: Label3D
@export var camera_reference : Marker3D

@onready var camera : Camera = PATHS.camera
@onready var inventory : Inventory = PATHS.inventory

var timestamps = []
var characters = []
var subtitles = {}

func _ready() -> void:
	SIGNALBUS.item_selected.connect(_on_item_selected)

func mouse_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		camera.transition(camera_reference.global_transform)
		await camera.finished_transition
		inventory.open()
		inventory.can_be_closed = false
		inventory.can_be_opened = false
		inventory.can_inspect_items = false

func on_mouse_exited() -> void:
	pass

var subtitle_margin = 0.5
func _process(_delta: float) -> void:
	if audio_stream_player.playing:
		var current_time = audio_stream_player.get_playback_position()
		for i in range(timestamps.size()):
			if current_time >= timestamps[i] - subtitle_margin and current_time < timestamps[i] + subtitle_margin:
				set_subtitle(i)
				break

func set_subtitle(index : int) -> void:
	var actual_language = TranslationServer.get_locale()
	var text = characters[index] + ": " + subtitles[actual_language][index]
	lbl_subtitles.text = text
	lbl_subtitles_3d.text = text

func _on_item_selected(item : Item) -> void:
	if item is TapeResource:
		load_subtitles_from_csv(item.csv_subtitles)
		audio_stream_player.stream = item.audio
		audio_stream_player.play()

func load_subtitles_from_csv(csv_path: String) -> void:
	timestamps.clear()
	characters.clear()
	subtitles.clear()
	
	# Verificar que el archivo existe
	if not FileAccess.file_exists(csv_path):
		push_error("CSV file not found: " + csv_path)
		return
	
	# Abrir el archivo CSV
	var file = FileAccess.open(csv_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open CSV file: " + csv_path)
		return
	
	# Leer la primera línea (encabezados)
	var header_line = file.get_line()
	var headers = parse_csv_line(header_line)
	
	# Identificar las columnas de idiomas (todas después de "character")
	var language_columns = []
	for i in range(2, headers.size()):  # Empezar desde índice 2 (después de timestamp y character)
		var lang = headers[i].strip_edges()
		language_columns.append(lang)
		subtitles[lang] = []  # Inicializar array para cada idioma
	
	# Leer las líneas restantes
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		
		# Saltar líneas vacías
		if line.is_empty():
			continue
		
		var columns = parse_csv_line(line)
		
		# Asegurarse de que la línea tenga suficientes columnas
		if columns.size() < 2:
			continue
		
		# Extraer timestamp (columna 0)
		var timestamp_str = columns[0].strip_edges()
		var timestamp = 0.0
		if not timestamp_str.is_empty():
			timestamp = float(timestamp_str)
		timestamps.append(timestamp)
		
		# Extraer character (columna 1)
		var character = columns[1].strip_edges() if columns.size() > 1 else ""
		characters.append(character)
		
		# Extraer subtítulos para cada idioma (columnas 2+)
		for i in range(language_columns.size()):
			var lang = language_columns[i]
			var subtitle_text = ""
			if columns.size() > (2 + i):
				subtitle_text = columns[2 + i].strip_edges()
			subtitles[lang].append(subtitle_text)
	
	file.close()

func parse_csv_line(line: String) -> Array:
	var columns = []
	var current_column = ""
	var in_quotes = false
	
	for i in range(line.length()):
		var _char = line[i]
		
		if _char == '"':
			in_quotes = not in_quotes
		elif _char == ';' and not in_quotes:
			columns.append(current_column)
			current_column = ""
		else:
			current_column += _char
	
	# Agregar la última columna
	columns.append(current_column)
	
	return columns
		