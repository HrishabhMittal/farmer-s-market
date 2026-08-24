# The design of the slot that is used in the InventoryUI

extends Control
class_name SlotUI

@export var slot_texture_node: TextureRect
@export var slot_label_node: Label

func refresh_slot(item: Item) -> void:
	if item:
		slot_texture_node.texture = item.item_data.item_texture
		slot_label_node.text = str(item.amount)
	else:
		slot_texture_node.texture = null
		slot_label_node.text = ""
