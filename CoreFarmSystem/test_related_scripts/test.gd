extends Node2D

func _ready():
	test()

func test() -> void:
	add_child(InventoryManager.make_new_palyer_inventory(21))
	InventoryManager.add_item("potato_seed", 50)
	InventoryManager.add_item("tomato_seed", 50)
	InventoryManager.add_item("pumpkin_seed", 50)
