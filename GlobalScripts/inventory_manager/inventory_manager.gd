extends Node

@export var inventory_ui_scene: PackedScene

var open_inventories: Array[Inventory]
var barn_ui: InventoryUI
var player_ui: InventoryUI

func _ready():
	SignalBus.inventory_opned.connect(register_open_inventory)
	SignalBus.inventory_closed.connect(unregister_closed_inventory)
	
	StateManager.barn_inventory = Inventory.new(100) 
	StateManager.player_inventory = Inventory.new(20)
	StateManager.active_seed_inventory = Inventory.new(1)
	
	barn_ui = inventory_ui_scene.instantiate()
	barn_ui.initialize(StateManager.barn_inventory)
	barn_ui.set_inventory_name("Barn")
	add_child(barn_ui)
	barn_ui.visible = false
	
	player_ui = inventory_ui_scene.instantiate()
	player_ui.initialize(StateManager.player_inventory, InventoryUI.InventoryPosition.BOTTOM_RIGHT)
	player_ui.set_inventory_name("Backpack")
	add_child(player_ui)
	player_ui.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if get_tree().current_scene and get_tree().current_scene.name == "FarmScene":
			if player_ui:
				if player_ui.visible:
					AudioManager.play_sfx("close menu sfx")
				else:
					AudioManager.play_sfx("open menu sfx")
				player_ui.visible = !player_ui.visible
				player_ui.refresh_inventory()
				
				# Check if Barn is nearby via InteractRadius
				var is_near_barn = false
				var player = get_tree().get_first_node_in_group("Player")
				if player:
					var interact_radius = player.get_node_or_null("InteractRadius")
					if interact_radius:
						for area in interact_radius.nearby_interactables:
							if area.name == "Barn":
								is_near_barn = true
								break
								
				# Sync barn visibility to player UI visibility if nearby
				if is_near_barn:
					barn_ui.visible = player_ui.visible
					if barn_ui.visible:
						barn_ui.refresh_inventory()
				else:
					barn_ui.visible = false

func register_open_inventory(new_inventory: Inventory) -> void:
	open_inventories.append(new_inventory)
	
func unregister_closed_inventory(new_inventory: Inventory) -> void:
	open_inventories.erase(new_inventory)
	
func close_all_uis() -> void:
	if barn_ui:
		barn_ui.visible = false
	if player_ui:
		player_ui.visible = false

func is_same_item(item1: Item, item2: Item) -> bool:
	if item1 and item2:
		if item1.item_data == item2.item_data:
			return true
	return false

# Targets player inventory instead of truck
func buy_item(item_id: String, cost: int, amount: int = 1) -> bool:
	if StateManager.money >= cost:
		var new_item = _make_item(item_id, amount)
		if new_item and StateManager.player_inventory.add_item(new_item, amount):
			StateManager.money -= cost
			return true
	return false

# Targets player inventory instead of truck
func sell_item(item_id: String, price: int, amount: int = 1) -> bool:
	var item_to_sell = _make_item(item_id, amount)
	if item_to_sell and StateManager.player_inventory.remove_item(item_to_sell, amount):
		StateManager.money += (price * amount)
		return true
	return false

func add_item_to_barn(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item:
		return false
	return StateManager.barn_inventory.add_item(new_item, amount)

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
	
func quick_transfer_item(slot_ui: SlotUI) -> bool:
	if not slot_ui.current_item or not slot_ui.connected_inventory:
		return false
		
	var to_inventory: Inventory = null
	for i in range(open_inventories.size()-1, -1, -1):
		if open_inventories[i] != slot_ui.connected_inventory:
			to_inventory = open_inventories[i]
			
	if not to_inventory:
		return false
		
	return transfer_item(slot_ui.connected_inventory, to_inventory, slot_ui.slot_index)
	
func transfer_item(from_inventory: Inventory, to_inventory: Inventory, from_slot_index: int) -> bool:
	var item_to_transfer = from_inventory.slots[from_slot_index]
	var transfer_success: bool = to_inventory.add_item(item_to_transfer, item_to_transfer.amount) 
	
	if not transfer_success:
		from_inventory.slot_changed.emit(from_slot_index)
		return false
		
	from_inventory.replace_item(null, from_slot_index)
	return true
