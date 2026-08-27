extends Node2D

@export var farm_tile_manager: FarmTileManager
@export var tool_manager: FarmToolManager
@export var is_test_enabled: bool = false

var seed_slot: SlotUI

func _ready():
	tool_manager.initialize(farm_tile_manager)
	
	seed_slot = load("res://InventorySystem/inventory_ui/slot_ui.tscn").instantiate()
	seed_slot.connected_inventory = InventoryManager.active_seed_inventory
	seed_slot.slot_index = 0
	
	# Connect to a standard method instead of a lambda to prevent memory crashes
	InventoryManager.active_seed_inventory.slot_changed.connect(_on_seed_slot_changed)
	
	$ToolBar/HBoxContainer.add_child(seed_slot)
	$ToolBar/HBoxContainer/SeedPlanter.visible = true

	if is_test_enabled:
		test_stuff()

func _on_seed_slot_changed(slot_index: int) -> void:
	if seed_slot:
		seed_slot.refresh_slot(InventoryManager.active_seed_inventory.slots[slot_index])

func interact():
	InventoryManager.truck_ui.visible = false
	InventoryManager.barn_ui.visible = !InventoryManager.barn_ui.visible

func test_stuff() -> void:
	# Add some items to barn
	InventoryManager.add_item_to_barn("tomato_seed", 20)
	InventoryManager.add_item_to_barn("pumpkin_seed", 20)
	
	# Give some test items to the new player inventory
	InventoryManager.player_inventory.add_item(ItemManager.make_item("carrot_seed"), 15)
	InventoryManager.player_inventory.add_item(ItemManager.make_item("potato_seed"), 10)

	# Spawn some ground items
	for i in range(100):
		ItemManager.spawn_ground_item_from_id("potato", 20, Vector2(randi_range(100, 700), randi_range(100, 700)))
