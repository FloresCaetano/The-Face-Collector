class_name DialogueTokenizer
extends RefCounted

class DialogueToken extends RefCounted:
	var char: String = ""
	var params: Dictionary = {}

var tag_handlers: Dictionary = {}

func tokenize(raw_text: String) -> Array[DialogueToken]:
	var result: Array[DialogueToken] = []
	var i: int = 0
	var text_length: int = raw_text.length()
	
	while i < text_length:
		var start_bracket: int = raw_text.find("{", i)
		
		# Base case / fallback: if no curly brace is found, add the rest as plain text
		if start_bracket == -1:
			_add_plain_text(result, raw_text.substr(i))
			break
			
		# Add plain text before this bracket
		if start_bracket > i:
			_add_plain_text(result, raw_text.substr(i, start_bracket - i))
			
		var end_bracket: int = raw_text.find("}", start_bracket)
		if end_bracket == -1:
			# Unclosed opening bracket, treat the rest of the text as plain text
			_add_plain_text(result, raw_text.substr(start_bracket))
			break
			
		var tag_content: String = raw_text.substr(start_bracket + 1, end_bracket - start_bracket - 1)
		var tag_name: String = tag_content
		var tag_val: String = ""
		
		var equals_pos: int = tag_content.find("=")
		if equals_pos != -1:
			tag_name = tag_content.substr(0, equals_pos)
			tag_val = tag_content.substr(equals_pos + 1)
			
		var close_tag: String = "{/" + tag_name + "}"
		var close_tag_start: int = raw_text.find(close_tag, end_bracket + 1)
		
		if close_tag_start == -1:
			# If no closing tag is found, treat the opening bracket as plain text and advance
			_add_plain_text(result, "{")
			i = start_bracket + 1
			continue
			
		# Complete tag block found, apply recursive resolution
		var inner_text: String = raw_text.substr(end_bracket + 1, close_tag_start - end_bracket - 1)
		var inner_tokens: Array[DialogueToken] = tokenize(inner_text)
		
		if tag_handlers.has(tag_name):
			var handler: Callable = tag_handlers[tag_name]
			inner_tokens = handler.call(inner_tokens, tag_val)
			
		result.append_array(inner_tokens)
		i = close_tag_start + close_tag.length()
		
	return result

func _add_plain_text(tokens: Array[DialogueToken], text: String) -> void:
	for c in text:
		var token := DialogueToken.new()
		token.char = c
		tokens.append(token)
