
extends CanvasLayer

@export_file("*.tscn") var target_scene_path: String

@onready var exit_button: TextureButton = $MarginContainer/TextureButton

func _on_texture_button_pressed() -> void:
	if target_scene_path != "":
		InventoryManager.close_all_uis()
		TravelTransition.change_scene(target_scene_path)
	else:
		push_error("no target path scene")
