extends Node2D

func _ready():
	test()

func test() -> void:
	add_child(InventoryManager.make_new_palyer_inventory(10))
	InventoryManager.add_item("potato_seed", 5)
