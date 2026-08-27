extends Node2D
class_name Item

@export var item_data: ItemData
@export var amount: int

var owner_inventory: Inventory
var inventory_index: int

func _init(new_item_data: ItemData, new_amount: int):
	item_data = new_item_data
	amount = new_amount

func _to_string():
	if item_data:
		#return "Name: %s, Amount: %d, Owner_inv: %s, inv_index: %d" % [item_data.display_name, amount, owner_inventory, inventory_index]
		return "Name: %s, Amount: %d, inv_index: %d" % [item_data.display_name, amount, inventory_index]
	return "null"

func update_info(new_owner_inventory: Inventory, new_index: int) -> void:
	owner_inventory = new_owner_inventory
	inventory_index = new_index

func clear_info() -> void:
	owner_inventory = null
	inventory_index = -1
