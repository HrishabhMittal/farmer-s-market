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
var footstep_timer: Timer

func _ready() -> void:
	footstep_timer = Timer.new()
	footstep_timer.wait_time = 0.3
	footstep_timer.one_shot = true
	add_child(footstep_timer)

func handle_direction() -> void:
	direction = Input.get_vector(left_input, right_input, up_input, down_input)

func handle_movement() -> void:

	player.velocity = direction * speed
	
	if direction != Vector2.ZERO:
		var sprite = player.get_node_or_null("Sprite2D")
		if sprite:
			sprite.rotation = direction.angle() + (PI / 2.0)
		if footstep_timer.is_stopped():
			AudioManager.play_sfx_random_pitch("walk", 0.9, 1.1)
			footstep_timer.start()

func _physics_process(_delta: float) -> void:
	if not player:
		return
	handle_direction()
	handle_movement()
	player.move_and_slide()
