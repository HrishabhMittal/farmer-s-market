extends TextureButton

@export_file("*.tscn") var target_scene_path: String

func _on_pressed() -> void:
	if target_scene_path != "":
		if StateManager.visited_scenes.is_empty():
			await CutsceneManager.transition_with_cutscene("start", target_scene_path)
		else:
			TravelTransition.change_scene(target_scene_path)
