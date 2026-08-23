extends Node

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
	
	return null
