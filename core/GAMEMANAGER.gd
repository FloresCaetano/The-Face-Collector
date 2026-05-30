extends Node

var look_sensitivity : float = 0.1

func _init() -> void:
	TranslationServer.set_locale("en")

var temp_diag_reader : DialogueReader

func bark_dialogue(file_name : String, limits : Array[int], targets : Array[DialogueTarget] = []) -> void:
	if temp_diag_reader:
		push_error("A dialogue is already being barked. Wait for it to finish before barking another one.")
		return
	
	temp_diag_reader = load("uid://yiosuuu5hda").instantiate()
	add_child(temp_diag_reader)
	
	temp_diag_reader.dialogue_file = "res://DIALOGUES/Chapter" + GAMESTATE.current_chapter + "/" + file_name + ".json"
	temp_diag_reader.dialogue_targets = targets
	temp_diag_reader.current_line = limits[0]
	temp_diag_reader.start()
	
	var line_sended := -1
	while line_sended < limits[1]: #CHECK IF THE UPPER LIMIT IS REACHED
		await temp_diag_reader.line_sended
		line_sended = temp_diag_reader.current_line
	
	temp_diag_reader.can_continue = false
	await temp_diag_reader.dialogue_finished #WAIT FOR THE DIALOGUE TO FINISH CLEANLY
	
	remove_child(temp_diag_reader)
	temp_diag_reader.queue_free()
	temp_diag_reader = null

func _on_dialogue_line_send(line): #All Dialogue readears are connected to this
	pass
