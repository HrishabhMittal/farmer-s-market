extends Area2D

# this node does the following:
# click on it and player_node will go to this
# click on it again when player is above it to move to the target_scene


@export_file("*.tscn") var target_scene_path: String 
@export var player_node: CharacterBody2D
var target_pos = Vector2(0,0)

const INTERACTION_DISTANCE = 5.0

func _process(delta: float) -> void:
	if global_position == Vector2(-401.0,98.0):
		target_pos = Vector2(-278,137)
	elif global_position == Vector2(97,-222):
		target_pos = Vector2(-15,-164)
	elif global_position == Vector2(390,-55):
		target_pos = Vector2(287,-29)

@warning_ignore("unused_parameter")
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if player_node:
				var distance = target_pos.distance_to(player_node.global_position)
				if distance<INTERACTION_DISTANCE:
					TravelTransition.change_scene(target_scene_path)
				else:	
					player_node.travel_to_building(target_pos)
