extends Node
class_name MovementComponent

@export var player: CharacterBody2D

@export_group("movement options")
@export var speed: float

@export_group("inputs options")
@export var left_input: StringName
@export var right_input: StringName
@export var up_input: StringName
@export var down_input: StringName

var direction: Vector2

func handle_direction() -> void:
	direction = Input.get_vector(left_input, right_input, up_input, down_input)

func handle_movement() -> void:
	# Directly set velocity to the target speed and direction
	player.velocity = direction * speed

func _physics_process(_delta: float) -> void:
	if not player: return
	handle_direction()
	handle_movement()
	player.move_and_slide()
