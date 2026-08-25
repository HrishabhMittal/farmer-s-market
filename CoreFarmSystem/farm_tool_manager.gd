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
	# Replace this input check with a "tool_use" input command
	if event.is_action_pressed("right click"):
		selected_tool = FarmTools.NONE
	
	if event.is_action_pressed("use_farm_tool"):
		match selected_tool:
			FarmTools.SHOVEL:
				if tile_manager.get_tile_type(get_global_mouse_position()) == "grass":
					dig_ground()
			FarmTools.HOE:
				if tile_manager.get_tile_type(get_global_mouse_position()) == "dirt":
					till_ground()
			FarmTools.WATERING_CAN:
				if tile_manager.get_tile_type(get_global_mouse_position()) == "tilled":
					water_ground()
			FarmTools.SEED_PLANTER:
				var tile_under_mouse: String = tile_manager.get_tile_type(get_global_mouse_position())
				#prints("\n___________________\ntile_under_mouse ", tile_under_mouse)
				#prints("tile_manager.is_crop_planted(get_global_mouse_position()): ", tile_manager.is_crop_planted(get_global_mouse_position()))
				if not tile_manager.is_crop_planted(get_global_mouse_position()):
					if tile_under_mouse == "tilled" or tile_under_mouse == "watered":
						# Add code to check if the tile is alreaady occupied with a plant or not
						#prints("PlayerHeldItem.is_held_item_seed(): ", PlayerHeldItem.is_held_item_seed())
						if PlayerHeldItem.is_held_item_seed():
							plant_seed()

func handle_new_tool_selection(new_tool: FarmTool) -> void:
	selected_tool = new_tool.tool_type

func plant_seed() -> void:
	#tile_manager.print_planted_crops()
	var seed_on_player_mouse: Item = PlayerHeldItem.get_held_item()
	if PlayerHeldItem.consume_item():
		var new_plant: FarmPlant = seed_on_player_mouse.item_data.scene_to_instantiate.instantiate()
		add_child(new_plant)
		new_plant.tile_manager = tile_manager
		new_plant.global_position = tile_manager.get_tile_center(get_global_mouse_position())
		tile_manager.crop_planted(get_global_mouse_position())
		#tile_manager.print_planted_crops()
	else:
		prints("Failed to plant")
	
func dig_ground() -> void:
	tile_manager.dig_ground()
	
func till_ground() -> void:
	tile_manager.till_ground()
	
func water_ground() -> void:
	tile_manager.water_ground()
