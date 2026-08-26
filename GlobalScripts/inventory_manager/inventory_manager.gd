extends Node

@export var inventory_ui_scene: PackedScene

var money: int = 500

var barn_inventory: Inventory
var truck_inventory: Inventory

var barn_ui: InventoryUI
var truck_ui: InventoryUI

func _ready():
	barn_inventory = Inventory.new(50) 
	truck_inventory = Inventory.new(30)
	
	barn_ui = inventory_ui_scene.instantiate()
	barn_ui.initialize(barn_inventory)
	barn_ui.get_node("PanelContainer/VBoxContainer/Label").text = "Barn"
	add_child(barn_ui)
	barn_ui.visible = false
	
	truck_ui = inventory_ui_scene.instantiate()
	truck_ui.initialize(truck_inventory)
	truck_ui.get_node("PanelContainer/VBoxContainer/Label").text = "Truck"
	add_child(truck_ui)
	truck_ui.visible = false

func close_all_uis() -> void:
	if barn_ui: barn_ui.visible = false
	if truck_ui: truck_ui.visible = false

func buy_item(item_id: String, cost: int, amount: int = 1) -> bool:
	if money >= cost:
		var new_item = _make_item(item_id, amount)
		if new_item and truck_inventory.add_item(new_item, amount):
			money -= cost
			return true
	return false

func sell_item(item_id: String, price: int, amount: int = 1) -> bool:
	var item_to_sell = _make_item(item_id, amount)
	if item_to_sell and truck_inventory.remove_item(item_to_sell, amount):
		money += (price * amount)
		return true
	return false

func add_item_to_barn(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item: return false
	return barn_inventory.add_item(new_item, amount)

func add_item_to_truck(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item: return false
	return truck_inventory.add_item(new_item, amount)

func does_have_item_in_truck(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item: return false
	return truck_inventory.does_have_item(new_item, amount)

func _make_item(item_id: String, amount: int = 0) -> Item:
	var data = ItemManager.get_item(item_id)
	if not data:
		push_error("no item named: ", item_id)
		return null
	return Item.new(data, amount)

func swap_item(from_inventory: Inventory, to_inventory: Inventory, from_slot_index: int, to_slot_index: int) -> void:
	var temp_from_item: Item = from_inventory.slots[from_slot_index]
	from_inventory.replace_item(to_inventory.slots[to_slot_index], from_slot_index)
	to_inventory.replace_item(temp_from_item, to_slot_index)
