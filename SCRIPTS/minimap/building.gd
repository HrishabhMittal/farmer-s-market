extends Area2D

# this node does the following:
# click on it and player_node will go to this
# click on it again when player is above it to move to the target_scene


@export_file("*.tscn") var target_scene_path: String 
@export var player_node: CharacterBody2D
const INTERACTION_DISTANCE = 5.0

@warning_ignore("unused_parameter")
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("input detected")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if player_node:
				var distance = global_position.distance_to(player_node.global_position)
				if distance<INTERACTION_DISTANCE:
					get_tree().change_scene_to_file(target_scene_path)
				else:	
					player_node.travel_to_building(global_position)
