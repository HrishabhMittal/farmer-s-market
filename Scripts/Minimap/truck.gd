extends CharacterBody2D

const SPEED = 150.0
var is_moving = false
var pending_scene_path: String = ""

@onready var truck_sprite = $AnimatedSprite2D

func _ready() -> void:
	if StateManager.position_set_once:
		global_position = StateManager.target_position

func _physics_process(delta: float) -> void:
	if is_moving:
		global_position = global_position.move_toward(StateManager.target_position, SPEED * delta)
		if global_position.distance_to(StateManager.target_position) < 1.0:
			truck_sprite.stop()
			is_moving = false
			
			if pending_scene_path != "":
				TravelTransition.change_scene(pending_scene_path)
				pending_scene_path = "" # Reset to prevent multiple calls
		else:
			truck_sprite.play("default")
			if global_position.x < StateManager.target_position.x:
				truck_sprite.flip_h = false
			else:
				truck_sprite.flip_h = true

func travel_to_building(target: Vector2, scene_path: String = ""):
	StateManager.position_set_once = true
	StateManager.target_position = target
	pending_scene_path = scene_path
	is_moving = true
