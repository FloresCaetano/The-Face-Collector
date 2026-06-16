extends EventBehavior


@export var basement_portrait : BasementPortrait
@onready var inventory : Inventory = PATHS.inventory

@export var position : int = 0

func execute() -> void:
	if inventory.has_item_by_class("BasementPortrait"):
		inventory.remove_item_by_tag(basement_portrait.item.tag)
		add_sibling(basement_portrait)

func _on_portrait_taked():
	pass
