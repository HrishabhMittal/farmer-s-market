extends Area2D

@export_file("*.tscn") var target_scene_path: String 
@export var player_node: CharacterBody2D

@onready var target_pos = global_position
var hover_tween: Tween

# would love to add a more elegant solution but gotta work with this
@export var is_home: bool = false

func _ready() -> void:
	pass

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if player_node:
				player_node.travel_to_building(target_pos, target_scene_path, is_home)

func _on_mouse_entered() -> void:

	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()
	scale = Vector2(1.1, 1.1)
	
	hover_tween = create_tween().set_loops()
	
	hover_tween.tween_property(self, "rotation_degrees", 5.0, 0.1).set_trans(Tween.TRANS_SINE)
	hover_tween.tween_property(self, "rotation_degrees", -5.0, 0.2).set_trans(Tween.TRANS_SINE)
	hover_tween.tween_property(self, "rotation_degrees", 0.0, 0.1).set_trans(Tween.TRANS_SINE)


func _on_mouse_exited() -> void:
	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()

	var exit_tween = create_tween().set_parallel(true)
	exit_tween.tween_property(self, "scale", Vector2.ONE, 0.15)
	exit_tween.tween_property(self, "rotation_degrees", 0.0, 0.15)
