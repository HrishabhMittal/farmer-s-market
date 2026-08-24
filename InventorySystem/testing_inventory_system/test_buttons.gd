# Just for unit testing

extends CanvasLayer

@export var add_cherry: Button
@export var remove_cherry: Button
@export var add_apple: Button
@export var remove_apple: Button
@export var add_orange: Button
@export var remove_orange: Button

func _ready() -> void:
	add_cherry.pressed.connect(_on_add_cherry_pressed)
	remove_cherry.pressed.connect(_on_remove_cherry_pressed)
	add_apple.pressed.connect(_on_add_apple_pressed)
	remove_apple.pressed.connect(_on_remove_apple_pressed)
	add_orange.pressed.connect(_on_add_orange_pressed)
	remove_orange.pressed.connect(_on_remove_orange_pressed)

func _on_add_cherry_pressed() -> void:
	InventoryManager.add_item("pumpkin", 1)

func _on_remove_cherry_pressed() -> void:
	InventoryManager.remove_item("pumpkin", 1)
	
func _on_add_apple_pressed() -> void:
	InventoryManager.add_item("eggplant", 1)
	
func _on_remove_apple_pressed() -> void:
	InventoryManager.remove_item("eggplant", 1)
	
func _on_add_orange_pressed() -> void:
	InventoryManager.add_item("carrot", 1)
	
func _on_remove_orange_pressed() -> void:
	InventoryManager.remove_item("carrot", 1)
