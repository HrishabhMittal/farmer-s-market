extends TextureButton

@export_file("*.tscn") var target_scene_path: String

func _on_pressed() -> void:
	if target_scene_path != "":
		TravelTransition.change_scene(target_scene_path)
