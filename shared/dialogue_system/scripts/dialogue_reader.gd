class_name DialogueReader
extends Node

@onready var dialogue_loader: DialogueLoader = $DialogueLoader
@export_file("*.json") var dialogue_file: String
@export var dialogue_targets : Array[DialogueTarget]
@export var event_trigger : Node

@export_category("Variables")
@export var default_wait_time: float = 0.03
@export var punctuation_wait_time: float = 0.6

var dialogue_data: Dictionary
var current_line := 0
var targets : Dictionary = {}
var actual_target : DialogueTarget

var can_continue := true

signal dialogue_finished
signal line_sended(line : int)

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
		if target_needed == "internal_voice":
			targets[target_needed] = PATHS.internal_voice
			continue
		elif target_needed == "flashback_recording_voice":
			targets[target_needed] = PATHS.flashback_recording_voice
			continue
			
		if not loaded_ids.has(target_needed):
			push_error("Dialogue line with ID ", dialogue_line.ID, " references TARGET '", target_needed, "' which is not in the loaded dialogue_targets array.")
		else:
			targets[target_needed] = loaded_ids[target_needed]

func send_line():
	if dialogue_data.is_empty():
		push_error("Dialogue data is empty. Ensure the DialogueLoader is properly set up and loaded.")
		return
	
	if not can_continue:
		end_dialogue()
		return
	
	var keys := dialogue_data.keys()
	if current_line >= keys.size():
		end_dialogue()
		return
	
	var line_id : String = keys[current_line]
	var line_data : Dictionary = dialogue_data[line_id]
	
	var new_target : DialogueTarget = targets[line_data.TARGET]
	
	if actual_target != new_target: #This occours on target change
		if new_target.is_selected == true: return
		if actual_target: await actual_target.deselect()
		await new_target.select()
	
	actual_target = new_target
	
	#LINE SENDING PROCESS:
	actual_target.actual_line = line_data
	for token in filter_parsed_tokens(line_data.text):
		actual_target.next_token()
		await get_tree().create_timer(get_wait_time(token)).timeout
	await get_tree().create_timer(2.0).timeout
	line_sended.emit(current_line)
	
	if actual_target is DialogueTarget2D:
		actual_target.deselect()
	
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

func filter_parsed_tokens(original_tokens: Array) -> Array:
	var filtered_tokens: Array = []
	var inside_bbcode: bool = false
	
	for token in original_tokens:
		if token.char == "[":
			inside_bbcode = true
			continue
			
		if token.char == "]":
			inside_bbcode = false
			continue
			
		if inside_bbcode:
			continue
			
		filtered_tokens.append(token)
		
	return filtered_tokens
	
	

func end_dialogue():
	actual_target.deselect()
	dialogue_finished.emit()
	
	actual_target.deselect()
	reset_values()

func reset_values():
	dialogue_data = {}
	current_line = 0
	targets = {}
	actual_target = null
	can_continue = true
