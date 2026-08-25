extends Resource
class_name ItemData

#@export var item_id: String = "default" # This is in the ItemManager now
var item_id: String # It will be set by ItemManager when it loads all the items. id will be same as item file name
@export var display_name: String = "Default"
@export var item_texture: Texture2D = null
@export var value: int = 0
@export var item_type: Array[ItemTypes.ItemType] = []
@export var scene_to_instantiate: PackedScene
