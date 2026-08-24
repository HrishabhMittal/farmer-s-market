# Just for unit testing

extends Node2D

@export var inventory: Inventory

func _ready():
	add_child(InventoryManager.make_new_palyer_inventory(50))
	
