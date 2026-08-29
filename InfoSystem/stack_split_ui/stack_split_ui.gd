extends PanelContainer
class_name StackSplitUI

@export var label_node: Label
@export var slider_node: HSlider
@export var accept_button: Button

func initialize(slot_ui: SlotUI) -> void:
	slider_node.max_value = int(slot_ui.current_item.amount)
	slider_node.value = int(slot_ui.current_item.amount)
	
	slider_node.value_changed.connect(update_label)
	accept_button.pressed.connect(accept_split.bind(slot_ui))
	update_label(slot_ui.current_item.amount)

func update_label(new_value: float) -> void:
	label_node.text = str(int(new_value))

func accept_split(slot_ui: SlotUI) -> void:
	if slot_ui.connected_inventory:
		var amount_to_take: int = slider_node.value
		var amount_to_keep: int = slot_ui.current_item.amount - amount_to_take
		
		var kept_item: Item = ItemManager.make_item(slot_ui.current_item.item_data.item_id, amount_to_keep)
		slot_ui.connected_inventory.replace_item(kept_item, slot_ui.slot_index)
		
		var picked_item: Item = ItemManager.make_item(slot_ui.current_item.item_data.item_id, amount_to_take)
		PlayerHeldItem.pick_item(picked_item, slot_ui, true)
	call_deferred("queue_free")
	
func _unhandled_input(event):
	if event.is_action_pressed("left click") or event.is_action_pressed("right click"):
		call_deferred("queue_free")
