extends Node2D

@export var farm_tile_manager: FarmTileManager
@export var tool_manager: FarmToolManager
@export var is_test_enabled: bool = false

func _ready():
	tool_manager.initialize(farm_tile_manager)
	if not is_test_enabled:
		$test.visible = false
		$test.process_mode = Node.PROCESS_MODE_DISABLED
