
extends CanvasLayer

@export_file("*.tscn") var target_scene_path: String

@onready var exit_button: TextureButton = $MarginContainer/TextureButton

func _on_texture_button_pressed() -> void:
	if target_scene_path != "":
		TravelTransition.change_scene(target_scene_path)
	else:
		push_error("Exit Button pressed, but no target scene path was set!")
