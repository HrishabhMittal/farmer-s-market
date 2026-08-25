extends TextureButton

@export_file("*.tscn") var target_scene_path: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if target_scene_path != "":
		get_tree().change_scene_to_file(target_scene_path)
