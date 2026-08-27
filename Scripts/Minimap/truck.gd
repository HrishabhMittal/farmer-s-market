extends CharacterBody2D

# this node with behave as follows:
# click on a building:
# - if not current building move to it
# - else open the scene of the current building (this is handled by the building)

# to implement:
# paths and roads, not just movement in any direction
# find shortest path to selected node, simple graph traversal using dijkstra


const SPEED = 150.0

var is_moving = false
@onready var truck_sprite = $AnimatedSprite2D

func _ready() -> void:
	if StateManager.position_set_once:
		global_position = StateManager.target_position

func _physics_process(delta: float) -> void:
	if is_moving:
		global_position = global_position.move_toward(StateManager.target_position, SPEED * delta)
		# check if we have arrived
		if global_position.distance_to(StateManager.target_position) < 1.0:
			truck_sprite.stop()
			is_moving = false
		else:
			truck_sprite.play("default")
			if global_position.x < StateManager.target_position.x:
				truck_sprite.flip_h = false
			else:
				truck_sprite.flip_h = true

func travel_to_building(target: Vector2):
	StateManager.position_set_once = true
	StateManager.target_position = target
	is_moving = true
