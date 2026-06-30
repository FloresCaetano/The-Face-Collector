extends EventBehavior


@export var requiered_portrait : Item
@onready var inventory : Inventory = PATHS.inventory
@onready var contextual_inventory : ContextualInventory = PATHS.contextual_inventory

@export var placed_portrait_item : Item
var placer_portrait_model : Node3D
var is_portrait_well_placed = false

func _ready() -> void:
	await get_tree().process_frame
	if placed_portrait_item:
		_on_item_selected(placed_portrait_item)

func execute() -> void:
	if placed_portrait_item:
		inventory.add_item(placed_portrait_item)
		placed_portrait_item = null
		placer_portrait_model.queue_free()
		event_finished.emit()
		return
	
	var items : Array[Item] = inventory.get_items_by_tag("portrait")
	if items.size() > 0:
		contextual_inventory.item_list = items
		contextual_inventory.item_selected.connect(_on_item_selected)
		contextual_inventory.open()
		return
	
	event_finished.emit()
		

func _on_item_selected(item : Item):
	placed_portrait_item = item
	placer_portrait_model = item.model.instantiate()
	add_sibling(placer_portrait_model)
	inventory.remove_item(item)
	
	if placed_portrait_item == requiered_portrait:
		is_portrait_well_placed = true
	event_finished.emit()

func on_interaction_end() -> void:
	contextual_inventory.close()
	if contextual_inventory.item_selected.is_connected(_on_item_selected):
		contextual_inventory.item_selected.disconnect(_on_item_selected)

func _on_portrait_taked():
	pass
