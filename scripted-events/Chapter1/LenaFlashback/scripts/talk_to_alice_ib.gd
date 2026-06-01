extends EventBehavior

@export var dialogue_reader: DialogueReader

func execute() -> void:
	dialogue_reader.start()
