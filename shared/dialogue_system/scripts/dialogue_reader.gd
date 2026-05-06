class_name DialogueReader
extends Node

@onready var dialogue_loader: DialogueLoader = $DialogueLoader
@export_file("*.json") var dialogue_file: String
@export var dialogue_targets : Array[DialogueTarget]
@export var event_trigger : Node

@export_category("Variables")
@export var default_wait_time: float = 0.07
@export var punctuation_wait_time: float = 0.6

var dialogue_data: Dictionary
var current_line := 0
var targets : Dictionary = {}
var actual_target : DialogueTarget

signal dialogue_finished

func start():
	dialogue_loader.dialogue_file = dialogue_file
	dialogue_data = dialogue_loader.load_and_process_dialogue()
	load_targets()
	send_line()

func load_targets():
	var loaded_ids := {}
	for dialogue_target in dialogue_targets:
		loaded_ids[dialogue_target.target_id] = dialogue_target
	
	for dialogue_line in dialogue_data.values():
		var target_needed = dialogue_line.TARGET
		if target_needed == "harry_internal":
			targets[target_needed] = PATHS.harry_internal
			continue
		elif target_needed == "tape_recording":
			targets[target_needed] = PATHS.tape_recording_voice
			continue
			
		if not loaded_ids.has(target_needed):
			push_error("Dialogue line with ID ", dialogue_line.ID, " references TARGET '", target_needed, "' which is not in the loaded dialogue_targets array.")
		else:
			targets[target_needed] = loaded_ids[target_needed]

func send_line():
	if dialogue_data.is_empty():
		push_error("Dialogue data is empty. Ensure the DialogueLoader is properly set up and loaded.")
		return
	
	var keys := dialogue_data.keys()
	if current_line >= keys.size():
		end_dialogue()
		return
	
	var line_id : String = keys[current_line]
	var line_data : Dictionary = dialogue_data[line_id]
	
	actual_target = targets[line_data.TARGET]
	await actual_target.select()
	for token in line_data.text:
		actual_target.set_text(token)
		await get_tree().create_timer(get_wait_time(token)).timeout
	await get_tree().create_timer(2.0).timeout
	
	if line_data.has("GAME_EVENT"):
		var event_name = line_data["GAME_EVENT"]
		if event_trigger.has_method(event_name):
			await event_trigger.call(event_name)
		else:
			push_error("Dialogue line with ID ", line_id, " references GAME_EVENT '", event_name, "' which is not a method of the event_trigger node.")
	current_line += 1
	send_line()

func get_wait_time(token : RefCounted) -> float:
	if token.params.has("wait_time"):
		return token.params["wait_time"]
	elif token.char in [".", "!", "?"]:
		return punctuation_wait_time
	else:
		return default_wait_time

func end_dialogue():
	actual_target.deselect()
	dialogue_finished.emit()
