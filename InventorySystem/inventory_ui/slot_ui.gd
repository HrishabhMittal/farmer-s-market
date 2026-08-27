# The design of the slot that is used in the InventoryUI

extends Control
class_name SlotUI

@export var slot_texture_node: TextureRect
@export var slot_label_node: Label

var connected_inventory: Inventory
var slot_index: int

var current_item: Item

func _ready():
	gui_input.connect(_handle_gui_input)
	mouse_entered.connect(_highlight)
	mouse_exited.connect(_unhilight)

func refresh_slot(item: Item) -> void:
	if item:
		current_item = item
		slot_texture_node.texture = item.item_data.item_texture
		slot_label_node.text = str(item.amount)
	else:
		current_item = null
		slot_texture_node.texture = null
		slot_label_node.text = ""

func _handle_gui_input(event: InputEvent) -> void:
	# Check if it was a left click
	if event.is_action_pressed("left click"):
			PlayerHeldItem.pick_item(current_item, self)

func _highlight() -> void:
	if current_item:
		slot_texture_node.scale = Vector2(1.2, 1.2)
		InfocardManager.show_infocard(current_item)
	
func _unhilight() -> void:
	slot_texture_node.scale = Vector2(1.0, 1.0)
	InfocardManager.hide_infocard()
