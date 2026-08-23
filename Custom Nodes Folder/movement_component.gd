extends Node
class_name MovementComponent

@export var player: CharacterBody2D

@export_group("movement options")
@export var speed: float
@export var acceleration: float
@export var deceleration: float

@export_group("inputs options")
@export var left_input: StringName
@export var right_input: StringName
@export var up_input: StringName
@export var down_input: StringName

var direction: Vector2

func handle_direction() -> void:
	direction = Input.get_vector(left_input, right_input, up_input, down_input)

func handle_movement() -> void:
	if direction:
		player.velocity = player.velocity.lerp(speed * direction, acceleration)
	else:
		player.velocity = player.velocity.lerp(Vector2.ZERO, deceleration)

func _physics_process(_delta: float) -> void:
	if not player: return
	handle_direction()
	handle_movement()
	player.move_and_slide()
