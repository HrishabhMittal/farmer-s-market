extends Node2D

@export var farm_tile_manager: FarmTileManager
@export var tool_manager: FarmToolManager
@export var is_test_enabled: bool = false

var seed_slot: SlotUI

func _ready():
	add_to_group("save_state") 
	tool_manager.initialize(farm_tile_manager)
	
	seed_slot = load("res://InventorySystem/inventory_ui/slot_ui.tscn").instantiate()
	seed_slot.connected_inventory = StateManager.active_seed_inventory
	seed_slot.slot_index = 0
	
	StateManager.active_seed_inventory.slot_changed.connect(_on_seed_slot_changed)
	
	$ToolBar/HBoxContainer.add_child(seed_slot)
	$ToolBar/HBoxContainer/SeedPlanter.visible = true

	load_state() 
	if is_test_enabled:
		test_stuff()

func _exit_tree() -> void:
	save_state()
	StateManager.save_to_file()

func _on_seed_slot_changed(slot_index: int) -> void:
	if seed_slot:
		seed_slot.refresh_slot(StateManager.active_seed_inventory.slots[slot_index])

func interact():
	InventoryManager.truck_ui.visible = false
	InventoryManager.barn_ui.visible = !InventoryManager.barn_ui.visible

func test_stuff() -> void:
	InventoryManager.add_item_to_barn("tomato_seed", 20)
	InventoryManager.add_item_to_barn("pumpkin_seed", 20)
	#InventoryManager.add_item_to_barn("carrot_seed", 220)
	StateManager.player_inventory.add_item(ItemManager.make_item("carrot_seed"), 35)
	#StateManager.player_inventory.remove_item(ItemManager.make_item("carrot_seed"), 34)
	StateManager.player_inventory.add_item(ItemManager.make_item("potato_seed"), 10)
	for i in range(100):
		ItemManager.spawn_ground_item_from_id("potato", 20, Vector2(randi_range(100, 700), randi_range(100, 700)))

func save_state() -> void:
	var tile_data = {}
	for cell in farm_tile_manager.main_tiles.get_used_cells():
		var source_id = farm_tile_manager.main_tiles.get_cell_source_id(cell)
		var atlas = farm_tile_manager.main_tiles.get_cell_atlas_coords(cell)
		tile_data[str(cell.x) + "," + str(cell.y)] = [source_id, atlas.x, atlas.y]
	StateManager.farm_tiles = tile_data
	
	var plant_data = []
	for child in get_children():
		if child is FarmPlant:
			plant_data.append({
				"crop_id": child.produced_crop_id,
				"pos_x": child.global_position.x,
				"pos_y": child.global_position.y,
				"growth_time": child.current_growth_time,
				"cycle": child.current_growth_cycle,
				"amount": child.production_amount
			})
	StateManager.farm_plants = plant_data
	StateManager.farm_planted_tiles = farm_tile_manager.planted_tiles.duplicate()
	
	var g_items = []
	for child in ItemManager.ground_item_root.get_children():
		if child is GroundItem:
			g_items.append({
				"id": child.item.item_data.item_id,
				"amount": child.item.amount,
				"x": child.global_position.x,
				"y": child.global_position.y
			})
		child.queue_free()
	StateManager.farm_ground_items = g_items
	
	StateManager.last_farm_save_time = Time.get_unix_time_from_system()

func load_state() -> void:
	if not StateManager.farm_tiles.is_empty():
		farm_tile_manager.main_tiles.clear()
		for key in StateManager.farm_tiles:
			var parts = key.split(",")
			var cell = Vector2i(int(parts[0]), int(parts[1]))
			var saved_arr = StateManager.farm_tiles[key]
			
			var source_id = 1
			var atlas = Vector2i.ZERO
			if saved_arr.size() == 3:
				source_id = int(saved_arr[0])
				atlas = Vector2i(int(saved_arr[1]), int(saved_arr[2]))
			else:
				atlas = Vector2i(int(saved_arr[0]), int(saved_arr[1]))
				
			farm_tile_manager.main_tiles.set_cell(cell, source_id, atlas)
			
	var missed_ticks = 0
	if StateManager.last_farm_save_time > 0:
		var time_away = Time.get_unix_time_from_system() - StateManager.last_farm_save_time
		missed_ticks = int(time_away / SignalBus.TICK_TIME)

	for child in get_children():
		if child is FarmPlant:
			child.queue_free()

	for p_data in StateManager.farm_plants:
		var seed_id = p_data["crop_id"] + "_seed"
		var item_data = ItemManager.get_item(seed_id)
		
		if item_data and item_data.scene_to_instantiate:
			var new_plant = item_data.scene_to_instantiate.instantiate()
			
			new_plant.tile_manager = farm_tile_manager
			new_plant.global_position = Vector2(p_data["pos_x"], p_data["pos_y"])
			new_plant.current_growth_time = p_data["growth_time"]
			new_plant.current_growth_cycle = p_data["cycle"]
			new_plant.production_amount = p_data["amount"]
			
			add_child(new_plant)
			
			if new_plant.growth_cycle_texture.size() > new_plant.current_growth_cycle:
				new_plant.plant_texture.texture = new_plant.growth_cycle_texture[new_plant.current_growth_cycle]
			if new_plant.current_growth_cycle >= new_plant.growth_cycle_day.size():
				new_plant.is_fully_grown = true
				
			if missed_ticks > 0 and new_plant.has_method("process_missed_ticks"):
				new_plant.process_missed_ticks(missed_ticks)

	if not StateManager.farm_planted_tiles.is_empty():
		farm_tile_manager.planted_tiles.clear()
		for coord in StateManager.farm_planted_tiles:
			farm_tile_manager.planted_tiles[coord] = StateManager.farm_planted_tiles[coord]
			
	for child in ItemManager.ground_item_root.get_children():
		child.queue_free()
		
	for g_data in StateManager.farm_ground_items:
		ItemManager.spawn_ground_item_from_id(g_data["id"], g_data["amount"], Vector2(g_data["x"], g_data["y"]))
