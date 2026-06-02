extends EventBehavior

@onready var place_indicator_machine_can_oppener: Node3D = $"../.."
@export var machine_can_opener: MachineCanOpener


func execute() -> void:
	place_indicator_machine_can_oppener.visible = false
	machine_can_opener.visible = true
	machine_can_opener.active = true
	machine_can_opener.collision_layer = 0b1
	PATHS.inventory.remove_item_by_tag("machine_can_opener")
	place_indicator_machine_can_oppener.queue_free()
