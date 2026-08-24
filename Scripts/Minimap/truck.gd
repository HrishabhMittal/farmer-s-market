extends CharacterBody2D

# this node with behave as follows:
# click on a building:
# - if not current building move to it
# - else open the scene of the current building (this is handled by the building)

# to implement:
# paths and roads, not just movement in any direction
# find shortest path to selected node, simple graph traversal using dijkstra


const SPEED = 300.0
var target_position: Vector2
var is_moving = false


func _physics_process(delta: float) -> void:
	if is_moving:
		global_position = global_position.move_toward(target_position, SPEED * delta)
		
		# check if we have arrived
		if global_position.distance_to(target_position) < 1.0:
			is_moving = false

func travel_to_building(target: Vector2):
	target_position = target
	is_moving = true
