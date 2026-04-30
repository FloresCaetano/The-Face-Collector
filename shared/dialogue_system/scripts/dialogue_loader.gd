class_name DialogueLoader
extends Node

var dialogue_file: String

func load_and_process_dialogue() -> Dictionary:
	if dialogue_file.is_empty() or not FileAccess.file_exists(dialogue_file):
		push_error("Dialogue file is not assigned or does not exist: ", dialogue_file)
		return {}
		
	var file := FileAccess.open(dialogue_file, FileAccess.READ)
	var json_string := file.get_as_text()
	
	var json := JSON.new()
	var parse_err := json.parse(json_string)
	
	if parse_err != OK:
		push_error("JSON Parse Error on ", dialogue_file, ": ", json.get_error_message())
		return {}
		
	var raw_data = json.data
	if not raw_data is Array:
		push_error("Invalid dialogue format: expected an Array at the root.")
		return {}
		
	var final_dict: Dictionary = {}
	var tokenizer := DialogueTokenizer.new()
	
	for entry in raw_data:
		if not entry is Dictionary or not entry.has("ID"):
			continue
			
		var entry_id: String = str(entry["ID"])
		var new_entry: Dictionary = entry.duplicate(true)
		
		if new_entry.has("text") and new_entry["text"] is Dictionary:
			# Currently hardcoded to extract "ES" based on instructions
			var localized_texts = new_entry["text"]
			if localized_texts.has("ES"):
				var raw_text: String = localized_texts["ES"]
				var dialogue_tokens = tokenizer.tokenize(raw_text)
				new_entry["text"] = dialogue_tokens
			else:
				var empty_tokens: Array[DialogueTokenizer.DialogueToken] = []
				new_entry["text"] = empty_tokens
				
		final_dict[entry_id] = new_entry
	return final_dict
