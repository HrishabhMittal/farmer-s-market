extends Node2D

@export var farm_tile_manager: FarmTileManager
@export var tool_manager: FarmToolManager
@export var is_test_enabled: bool = false

func _ready():
	tool_manager.initialize(farm_tile_manager)
	if is_test_enabled:
		test_stuff()

func interact():
	InventoryManager.truck_ui.visible = false
	InventoryManager.barn_ui.visible = !InventoryManager.barn_ui.visible

func test_stuff() -> void:
	# Add some items to barn
	InventoryManager.add_item_to_barn("tomato_seed", 20)
	InventoryManager.add_item_to_barn("pumpkin_seed", 20)
	
	# Add some items to truck
	InventoryManager.add_item_to_truck("potato_seed", 10)
	
	# Make a test player inventory
	var new_player_inventory: Inventory = Inventory.new(5)
	var new_player_inventory_ui: InventoryUI = load("res://InventorySystem/inventory_ui/inventory_ui.tscn").instantiate()
	new_player_inventory_ui.initialize(new_player_inventory, InventoryUI.InventoryPosition.BOTTOM_RIGHT)
	add_child(new_player_inventory_ui)
	new_player_inventory_ui.visible = true
	
	# Give some items to players inventory
	new_player_inventory.add_item(ItemManager.make_item("tomato_seed"), 123)
	
