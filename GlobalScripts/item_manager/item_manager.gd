extends Node2D

@export var groud_item_scene: PackedScene
@export var ground_item_root: Node2D

var all_items: Dictionary [String, ItemData]
var item_folder_path: String = "res://InventorySystem/item/itemdata/"

func _ready():
	load_items_from_folder(item_folder_path)

func get_item(item_id: String) -> ItemData:
	var item: ItemData = all_items.get(item_id, null)
	if not item:
		push_error("Could not find ", item_id)
		return null
	return item

func make_item(item_id: String, amount: int = 0) -> Item:
	return Item.new(get_item(item_id), amount)

func load_items_from_folder(folder_path: String) -> void:
	var files: PackedStringArray = ResourceLoader.list_directory(folder_path)

	for file_name in files:
		var resource_path = folder_path.path_join(file_name)

		# Subfolders end with a "/", so check inside them too
		if file_name.ends_with("/"):
			load_items_from_folder(resource_path)
			continue

		# Skip Godot's import metadata files
		if file_name.ends_with(".import"):
			continue

		var key = file_name.get_basename()
		var resource: Resource = load(resource_path)

		if resource:
			if resource is ItemData:
				all_items[key] = resource
				resource.item_id = key
			else:
				printerr("Resource is not an ItemData, skipping: ", resource_path)
		else:
			printerr("Failed to load resource: ", resource_path)

func spawn_ground_item_from_id(item_id: String, new_amount: int = 1, spawn_location: Vector2 = get_global_mouse_position()) -> void:
	var item: Item = make_item(item_id, new_amount)
	if not item:
		push_error("There is not item with item_id: ", item_id)
		return
	
	var new_ground_item: GroundItem = groud_item_scene.instantiate()
	new_ground_item.initialize(item)
	ground_item_root.add_child(new_ground_item)
	new_ground_item.global_position = spawn_location

func spawn_ground_item(item: Item, new_amount: int = 0, spawn_location: Vector2 = get_global_mouse_position()) -> void:
	if new_amount > 0: # If player wants to overried the amout of the item
		item.amount = new_amount
	
	var new_ground_item: GroundItem = groud_item_scene.instantiate()
	new_ground_item.initialize(item)
	ground_item_root.add_child(new_ground_item)
	new_ground_item.global_position = spawn_location
