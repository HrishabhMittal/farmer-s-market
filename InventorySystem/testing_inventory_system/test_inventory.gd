extends Node2D

@export var inventory: Inventory

func _ready():
	inventory = Inventory.new(20)
	InventoryManager.player_inventory = inventory
	prints("New inventory with 20 slots made")
	
	inventory.print_inventory()
	InventoryManager.add_item("carrot", 12) # can use "eggplant", "carrot", "pumpkin" for now
	prints("Added 12 carrots to inventory")
	
	inventory.print_inventory()
	prints(inventory.slots[0].amount)
