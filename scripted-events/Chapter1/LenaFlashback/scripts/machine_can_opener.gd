extends Node3D

@onready var collectable_machine_can_opener: StaticBody3D = $CollectableMachineCanOpener
@onready var machine_can_opener: StaticBody3D = $MachineCanOpener
@onready var place_indicator_machine_can_oppener: Node3D = $PlaceIndicatorMachineCanOppener
@onready var interaction_trigger: InteractionTrigger = $PlaceIndicatorMachineCanOppener/InteractionTrigger


func _on_collectable_machine_can_opener_interacted() -> void:
	place_indicator_machine_can_oppener.visible = true
	interaction_trigger.active = true
