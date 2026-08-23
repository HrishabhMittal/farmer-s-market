extends Node

@export var all_items: Dictionary [String, ItemData]

func get_item(item_id: String) -> ItemData:
	var item: ItemData = all_items.get(item_id, null)
	if not item:
		push_error("Could not find", item_id)
		return null
	return item
