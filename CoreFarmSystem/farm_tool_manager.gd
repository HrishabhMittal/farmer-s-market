extends Node2D
class_name FarmToolManager

signal tool_selected(new_tool: FarmTool)

enum FarmTools {SHOVEL, HOE, WATERING_CAN, SEED_PLANTER, NONE}

var selected_tool: FarmTools = FarmTools.WATERING_CAN
var tile_manager: FarmTileManager

var is_using_tool: bool = false

func handle_new_tool_selection(new_tool: FarmTool) -> void:
	selected_tool = new_tool.tool_type
	
	var farm_scene = get_parent()
	if farm_scene and "seed_slot" in farm_scene and farm_scene.seed_slot:
		farm_scene.seed_slot.get_node("PanelContainer").add_theme_stylebox_override("panel", load("res://CoreFarmSystem/tool_unselected_theme.tres"))

func initialize(new_tile_manager: FarmTileManager) -> void:
	tile_manager = new_tile_manager
	tool_selected.connect(handle_new_tool_selection)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right click"):
		selected_tool = FarmTools.NONE
		is_using_tool = false
		var farm_scene = get_parent()
		if farm_scene and "seed_slot" in farm_scene and farm_scene.seed_slot:
			farm_scene.seed_slot.get_node("PanelContainer").add_theme_stylebox_override("panel", load("res://CoreFarmSystem/tool_unselected_theme.tres"))
			
	if event.is_action_pressed("use_farm_tool"):
		if not PlayerHeldItem.is_empty(): return
		is_using_tool = true
		_apply_tool()
	elif event.is_action_released("use_farm_tool"):
		is_using_tool = false

func _process(_delta: float) -> void:
	if is_using_tool:
		_apply_tool()


func _apply_tool() -> void:
	var mouse_pos = get_global_mouse_position()
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		var interact_area = player.get_node_or_null("InteractRadius")
		if interact_area:
			var col_shape = interact_area.get_node_or_null("CollisionShape2D")
			var max_distance = col_shape.shape.radius
			var tile_center = tile_manager.get_tile_center(mouse_pos)
			
			if player.global_position.distance_to(tile_center) > max_distance:
				return

	match selected_tool:
		FarmTools.SHOVEL:
			if tile_manager.get_tile_type(mouse_pos) == "grass":
				dig_ground()
		FarmTools.HOE:
			if tile_manager.get_tile_type(mouse_pos) == "dirt":
				till_ground()
		FarmTools.WATERING_CAN:
			if tile_manager.get_tile_type(mouse_pos) == "tilled":
				water_ground()
		FarmTools.SEED_PLANTER:
			var tile_under_mouse: String = tile_manager.get_tile_type(mouse_pos)
			if not tile_manager.is_crop_planted(mouse_pos):
				if tile_under_mouse == "tilled" or tile_under_mouse == "watered":
					var active_seed = StateManager.active_seed_inventory.slots[0]
					if active_seed and ItemTypes.ItemType.SEED in active_seed.item_data.item_type:
						plant_seed()

func plant_seed() -> void:
	var seed_item: Item = StateManager.active_seed_inventory.slots[0]
	if seed_item:
		var new_plant: FarmPlant = seed_item.item_data.scene_to_instantiate.instantiate()
		get_parent().add_child(new_plant)
		new_plant.generate_display_name(seed_item)
		new_plant.production_amount = GameConfig.crop_seed_yields.get(seed_item.item_data.item_id, 1) # Tries to get the seeds production amount from config , if fails to find id, sets it to 1
		new_plant.tile_manager = tile_manager
		new_plant.global_position = tile_manager.get_tile_center(get_global_mouse_position())
		tile_manager.crop_planted(get_global_mouse_position())
		StateManager.active_seed_inventory.remove_item(seed_item, 1)
	else:
		prints("failed to plant")

func dig_ground() -> void:
	tile_manager.dig_ground()

func till_ground() -> void:
	tile_manager.till_ground()

func water_ground() -> void:
	AudioManager.play_sfx_random_pitch("Water")
	tile_manager.water_ground()
