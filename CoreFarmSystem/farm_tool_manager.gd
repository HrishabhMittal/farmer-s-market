extends Node2D
class_name FarmToolManager

# All the tools are self explanatory
# The SEED_PLANTER will be selected when player has a seed picked up on the cursor
enum FarmTools {SHOVEL, HOE, WATERING_CAN, SEED_PLANTER}
var selected_tool: FarmTools = FarmTools.WATERING_CAN

var tile_manager: FarmTileManager

# Parent node will call it to initialize
func initialize(new_tile_manager: FarmTileManager) -> void:
	tile_manager = new_tile_manager

func _unhandled_input(event: InputEvent) -> void:
	# Replace this input check with a "tool_use" input command
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
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
