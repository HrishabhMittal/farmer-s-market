extends Area2D

enum PlotState { WEEDS, DIRT, TILLED, SEEDED, GROWN }
var current_state = PlotState.WEEDS
@export var player_node: CharacterBody2D
const interact_distance = 40.0

func _on_ready() -> void:
	update_visuals()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if player_node:
			var distance = global_position.distance_to(player_node.global_position)
			if distance > interact_distance:
				player_node.travel_to_building(global_position)
			else:
				interact_with_plot()


func interact_with_plot():
	# rn we really dont have assets so just cycle through the states
	match current_state:
		PlotState.WEEDS:
			current_state = PlotState.DIRT
		PlotState.DIRT:
			current_state = PlotState.TILLED
		PlotState.TILLED:
			current_state = PlotState.SEEDED
		PlotState.SEEDED:
			current_state = PlotState.GROWN
		PlotState.GROWN:
			current_state = PlotState.DIRT
			
	update_visuals()

func update_visuals():
	# changing the tiles would be done here
	match current_state:
		pass
