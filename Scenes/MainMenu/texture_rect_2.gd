extends TextureButton

func _on_pressed() -> void:
	get_tree().call_group("save_state", "save_state")
	StateManager.save_to_file()
	get_tree().quit()
