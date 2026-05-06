extends ColorRect

@export var btn_use : Button
@export var btn_inspect : Button 

@onready var inventory : Inventory = PATHS.inventory

signal item_selected(item : Item)
signal item_inspected(item : Item)

func set_visible_with_anim(_visible : bool):
	visible = _visible
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0 if _visible else 0.0, 0.2)

	btn_inspect.visible = inventory.can_inspect_items


func _on_btn_use_pressed() -> void:
	item_selected.emit(get_parent().item)


func _ready() -> void:
	item_inspected.connect(SIGNALBUS._on_item_inspected)

func _on_btn_inspect_toggled(toggled_on: bool) -> void:
	btn_inspect.text = tr("K_STOP_INSPECTING") if toggled_on else tr("K_INSPECT")
	item_inspected.emit(get_parent().item if toggled_on else null)
