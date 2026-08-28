extends CanvasLayer

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		is_open = !is_open
		update_panel_visiblity(is_open)

func update_panel_visiblity(direction: bool) -> void:
	match direction:
		true: anim_player.play("open")
		false: anim_player.play("close")
