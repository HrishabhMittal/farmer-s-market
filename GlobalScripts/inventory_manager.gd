extends Node

@export var inventory_ui_scene: PackedScene

var player_inventory: Inventory

func add_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = make_item(item_id, amount)
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	return player_inventory.add_item(new_item, amount)
	
func remove_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = make_item(item_id, amount)
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	return player_inventory.remove_item(new_item, amount)
	
func does_have_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = make_item(item_id, amount)
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	return player_inventory.does_have_item(new_item, amount)

func make_item(item_id: String, amount: int = 0) -> Item:
	return Item.new(ItemManager.get_item(item_id), amount)

func make_new_palyer_inventory(slot_count: int = 50) -> InventoryUI:
	var new_inventory := Inventory.new(50)
	player_inventory = new_inventory
	
	var new_inventory_ui: InventoryUI = inventory_ui_scene.instantiate()
	new_inventory_ui.initialize(new_inventory)
	
	return new_inventory_ui
