extends Node

@export var all_items: Dictionary [String, ItemData]

func get_item(item_id: String) -> ItemData:
	return all_items.get(item_id, null)
