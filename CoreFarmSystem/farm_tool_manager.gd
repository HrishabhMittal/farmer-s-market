extends Node2D
class_name FarmToolManager

signal tool_selected(new_tool: FarmTool)

# All the tools are self explanatory
# The SEED_PLANTER will be selected when player has a seed picked up on the cursor
enum FarmTools {SHOVEL, HOE, WATERING_CAN, SEED_PLANTER, NONE}
var selected_tool: FarmTools = FarmTools.WATERING_CAN

var tile_manager: FarmTileManager

# Parent node will call it to initialize
func initialize(new_tile_manager: FarmTileManager) -> void:
	tile_manager = new_tile_manager
	tool_selected.connect(handle_new_tool_selection)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right click"):
		selected_tool = FarmTools.NONE
	
	if event.is_action_pressed("use_farm_tool"):
		var mouse_pos = get_global_mouse_position()
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			var interact_area = player.get_node_or_null("InteractRadius")
			if interact_area:
				var col_shape = interact_area.get_node_or_null("CollisionShape2D")
				var max_distance = col_shape.shape.radius
				var tile_center = tile_manager.get_tile_center(mouse_pos)
				
				if player.global_position.distance_to(tile_center) > max_distance:
					print("too far 4 tool")
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
								# Check the new dedicated seed slot instead of PlayerHeldItem
								var active_seed = StateManager.active_seed_inventory.slots[0]
								if active_seed and ItemTypes.ItemType.SEED in active_seed.item_data.item_type:
									plant_seed()

func plant_seed() -> void:
	var seed_item: Item = StateManager.active_seed_inventory.slots[0]

	if seed_item:
		var new_plant: FarmPlant = seed_item.item_data.scene_to_instantiate.instantiate()
		add_child(new_plant)
		new_plant.tile_manager = tile_manager
		new_plant.global_position = tile_manager.get_tile_center(get_global_mouse_position())
		tile_manager.crop_planted(get_global_mouse_position())
		
		StateManager.active_seed_inventory.remove_item(seed_item, 1)
	else:
		prints("failed to plant")

func handle_new_tool_selection(new_tool: FarmTool) -> void:
	selected_tool = new_tool.tool_type

func dig_ground() -> void:
	tile_manager.dig_ground()
	
func till_ground() -> void:
	tile_manager.till_ground()
	
func water_ground() -> void:
	tile_manager.water_ground()
