extends Node

@export var inventory_ui_scene: PackedScene

var player_inventory: Inventory

# Gives item to player
func add_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	return player_inventory.add_item(new_item, amount)

# Removes item from player
func remove_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	return player_inventory.remove_item(new_item, amount)

# Check if player has this item
func does_have_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	return player_inventory.does_have_item(new_item, amount)

# For internal use, should not be called
func _make_item(item_id: String, amount: int = 0) -> Item:
	return Item.new(ItemManager.get_item(item_id), amount)

# Makes a new inventory for the player and returns the InventoryUI node. Attach the returned node to the tree to use
func make_new_palyer_inventory(slot_count: int = 50) -> InventoryUI:
	var new_inventory := Inventory.new(slot_count)
	player_inventory = new_inventory
	
	var new_inventory_ui: InventoryUI = inventory_ui_scene.instantiate()
	new_inventory_ui.initialize(new_inventory)
	
	return new_inventory_ui

# Swaps items between two inventories
func swap_item(from_inventory: Inventory, to_inventory: Inventory, from_slot_index: int, to_slot_index: int) -> void:
	# Store "from" item temporarily
	var temp_from_item: Item = from_inventory.slots[from_slot_index]
	
	# Now put the item from "to_inventory" to the "from_inventory"
	from_inventory.replace_item(to_inventory.slots[to_slot_index], from_slot_index)
	
	# Now put the temporarily stored item to the "to inventory"
	to_inventory.replace_item(temp_from_item, to_slot_index)

func _ready():
	add_child(make_new_palyer_inventory(21))
