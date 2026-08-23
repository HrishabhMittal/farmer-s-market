extends Resource
class_name Item

@export var item_data: ItemData
@export var amount: int

func _init(new_item_data: ItemData, new_amount: int):
	item_data = new_item_data
	amount = new_amount

func _to_string():
	if item_data:
		return "Name: %s, Amount: %d" %[item_data.display_name, amount]
	return "null"
