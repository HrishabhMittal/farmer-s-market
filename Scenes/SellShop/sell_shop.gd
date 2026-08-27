extends Node2D

@export var price_lower_limit: int = 10
@export var price_upper_limit: int = 60

@onready var price_label: Label = $CanvasLayer/PriceLabel

var item_prices: Dictionary = {}
var player_inventory_ui: InventoryUI

func _ready() -> void:
	add_to_group("sell_shop")
	
	player_inventory_ui = load("res://InventorySystem/inventory_ui/inventory_ui.tscn").instantiate()
	player_inventory_ui.initialize(InventoryManager.player_inventory, InventoryUI.InventoryPosition.BOTTOM_CENTER)
	player_inventory_ui.set_inventory_name("Player Inventory")
	add_child(player_inventory_ui)
	
	refresh_shop()

func refresh_shop() -> void:
	item_prices.clear()
	
	if ItemManager and ItemManager.all_items:
		for item_id in ItemManager.all_items.keys():
			var item_data = ItemManager.get_item(item_id)
			
			if item_data and ItemTypes.ItemType.VEGETABLE in item_data.item_type:
				item_prices[item_id] = randi_range(price_lower_limit, price_upper_limit)
	
	update_price_label()

func update_price_label() -> void:
	if not price_label:
		return
		
	var text = "=== Current Market Prices ===\n\n"
	
	for item_id in item_prices.keys():
		var display_name = ItemManager.get_item(item_id).display_name
		text += "%s: %d Coins\n" % [display_name, item_prices[item_id]]
		
	price_label.text = text

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if PlayerHeldItem and not PlayerHeldItem.is_empty():
			var held_item = PlayerHeldItem.get_held_item()
			if held_item and held_item.item_data:
				
				if ItemTypes.ItemType.VEGETABLE in held_item.item_data.item_type:
					var item_id = held_item.item_data.item_id
					var unit_price = item_prices.get(item_id, held_item.item_data.value)
					var total_sale = unit_price * held_item.amount
					
					InventoryManager.money += total_sale
					
					if InfocardManager:
						InfocardManager.show_floating_text("+%d Coins" % total_sale, get_global_mouse_position(), "Green")
					
					PlayerHeldItem.clear_item()
				else:
					if InfocardManager:
						InfocardManager.show_floating_text("Can only sell crops!", get_global_mouse_position(), "Red")
						
			get_viewport().set_input_as_handled()
