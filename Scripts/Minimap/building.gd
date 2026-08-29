extends Area2D

@export_file("*.tscn") var target_scene_path: String 
@export var player_node: CharacterBody2D

var hover_tween: Tween
var shake_tween: Tween
@export var target: Marker2D
# would love to add a more elegant solution but gotta work with this
@export var is_home: bool = false

func _ready() -> void:
	pass

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if player_node:
				player_node.travel_to_building(target.global_position, target_scene_path, is_home)

func _on_mouse_entered() -> void:
	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()

	hover_tween = create_tween()
	hover_tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
		
	shake_tween = create_tween()
	shake_tween.tween_property(self, "rotation_degrees", 6.0, 0.1)
	shake_tween.tween_property(self, "rotation_degrees", -6.0, 0.1)
	shake_tween.tween_property(self, "rotation_degrees", 3.0, 0.1)
	shake_tween.tween_property(self, "rotation_degrees", 0.0, 0.1)

func _on_mouse_exited() -> void:
	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
		
	var exit_tween = create_tween().set_parallel(true)
	exit_tween.tween_property(self, "scale", Vector2.ONE, 0.15)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	exit_tween.tween_property(self, "rotation_degrees", 0.0, 0.15)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
