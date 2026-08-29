extends Control

@export var play_button: TextureButton
@export var settings_button: TextureButton
@export var exit_button: TextureButton

func _ready() -> void:
	AudioManager.play_music("Farm Day Alternate")
	
	play_button.mouse_entered.connect(UIAnimationManager.scale_expand_shake_highlight.bind(play_button))
	play_button.mouse_exited.connect(UIAnimationManager.scale_expand_shake_unhighlight.bind(play_button))
