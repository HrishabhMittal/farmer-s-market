extends Node2D

@export var farm_tile_manager: FarmTileManager
@export var tool_manager: FarmToolManager

func _ready():
	tool_manager.initialize(farm_tile_manager)
	#test()

func test() -> void:
	add_child(InventoryManager.make_new_palyer_inventory(10))
	InventoryManager.add_item("pumpkin_seed", 5)
