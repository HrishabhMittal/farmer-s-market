extends Node2D
class_name FarmToolManager

signal tool_selected(new_tool: FarmTool)

# All the tools are self explanatory
# The SEED_PLANTER will be selected when player has a seed picked up on the cursor
enum FarmTools {SHOVEL, HOE, WATERING_CAN, SEED_PLANTER}
var selected_tool: FarmTools = FarmTools.WATERING_CAN

var tile_manager: FarmTileManager

# Parent node will call it to initialize
func initialize(new_tile_manager: FarmTileManager) -> void:
	tile_manager = new_tile_manager
	tool_selected.connect(handle_new_tool_selection)

func _unhandled_input(event: InputEvent) -> void:
	# Replace this input check with a "tool_use" input command
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
				if tile_under_mouse == "tilled" or tile_under_mouse == "watered":
					plant_seed()

func handle_new_tool_selection(new_tool: FarmTool) -> void:
	selected_tool = new_tool.tool_type

func plant_seed() -> void:
	if PlayerHeldItem.consume_item():
		prints("Seed Planted")
	else:
		prints("Failed to plant")
	
func dig_ground() -> void:
	tile_manager.dig_ground()
	
func till_ground() -> void:
	tile_manager.till_ground()
	
func water_ground() -> void:
	tile_manager.water_ground()
