extends Node

@export var all_items: Dictionary [String, ItemData]
var item_folder_path: String = "res://InventorySystem/item/itemdata/"

func _ready():
	load_items_from_folder(item_folder_path)

func get_item(item_id: String) -> ItemData:
	var item: ItemData = all_items.get(item_id, null)
	if not item:
		push_error("Could not find", item_id)
		return null
	return item

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
			else:
				printerr("Resource is not an ItemData, skipping: ", resource_path)
		else:
			printerr("Failed to load resource: ", resource_path)
