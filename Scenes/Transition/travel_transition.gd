extends CanvasLayer
@onready var container = $Control
@onready var anim_player = $AnimationPlayer
@onready var animated_sprite = $Control/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
var is_transitioning: bool = false
func _ready() -> void:
	container.hide()
	animated_sprite.position = get_viewport().get_visible_rect().size / 2.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_scene(next_scene_path: String):
	if is_transitioning:
		return
	is_transitioning = true
	container.show()
	
	animated_sprite.play("default")
	anim_player.play("dissolve")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(next_scene_path)
	await get_tree().create_timer(1.0).timeout

	anim_player.play_backwards("dissolve")
	await anim_player.animation_finished

	animated_sprite.stop()
	container.hide()
	is_transitioning = false
	
