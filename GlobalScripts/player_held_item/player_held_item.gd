# When player picks up item from inventory by clicking on it, this scene will manage showing that
# and also moving it to other slots

extends Node2D

@export var texture_node: TextureRect
@export var label_node: Label
@export var show_item_on_mouse: bool = true

var mouse_inventory: Inventory
var is_currently_showing: bool # If player is holding a item then it will be shown at mouse pointer if this variable is true

func _ready():
	mouse_inventory = Inventory.new(1)
	
func pick_item(item: Item, source_slot: SlotUI) -> void:
	if item:
		InventoryManager.swap_item(item.owner_inventory, mouse_inventory, item.inventory_index, 0) # '0' because mouse_inventory has only 1 slot
	else:
		InventoryManager.swap_item(source_slot.connected_inventory, mouse_inventory, source_slot.slot_index, 0)
	_show_item_on_mouse()
	
func remove_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	
	var result: bool = mouse_inventory.remove_item(new_item, amount)
	if result:
		_show_item_on_mouse()
	
	if is_empty():
		_hide_item_on_mouse()
	
	return result

# A shortcut version of "remove_item" function to consume given amount from the held item
func consume_item(amount: int = 1) -> bool:
	if not is_empty():
		return remove_item(get_held_item_id(), amount)
	return false

func has_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	return mouse_inventory.does_have_item(new_item, amount)

func _make_item(item_id: String, amount: int = 0) -> Item:
	return Item.new(ItemManager.get_item(item_id), amount)

func clear_item() -> void:
	mouse_inventory.make_empty()
	_hide_item_on_mouse()

func is_empty() -> bool:
	return mouse_inventory.is_empty()

# Returns the item on the mouse cursor
func get_held_item_id() -> String:
	return mouse_inventory.slots[0].item_data.item_id

# Shows the current item that player has picked on the mouse pointer
func _show_item_on_mouse() -> void:
	if mouse_inventory.is_empty():
		_hide_item_on_mouse()
		return
	#mouse_inventory.print_inventory()
	#prints(mouse_inventory.slots[0].item_data.item_texture)

	texture_node.texture = mouse_inventory.slots[0].item_data.item_texture
	label_node.text = str(mouse_inventory.slots[0].amount)
	is_currently_showing = true
	
func _hide_item_on_mouse() -> void:
	texture_node.texture = null
	label_node.text = ""
	is_currently_showing = false

func _process(_delta):
	if is_currently_showing:
		$CanvasLayer/ItemView.position = get_viewport().get_mouse_position()
