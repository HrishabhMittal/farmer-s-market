extends Control

@onready var play_button: TextureButton = $right_menu_container/VBoxContainer/Play
@onready var settings_button: TextureButton = $right_menu_container/VBoxContainer/Settings
@onready var exit_button: TextureButton = $right_menu_container/VBoxContainer/Exit
func _ready() -> void:
	AudioManager.play_music("Farm Day Alternate")
	
	# Play Button Animations
	play_button.mouse_entered.connect(UIAnimationManager.scale_expand_shake_highlight.bind(play_button))
	play_button.mouse_exited.connect(UIAnimationManager.scale_expand_shake_unhighlight.bind(play_button))
	
	# Settings
	settings_button.pressed.connect(func(): SettingMenu.toggle_settings())
	settings_button.mouse_entered.connect(UIAnimationManager.scale_expand_shake_highlight.bind(settings_button))
	settings_button.mouse_exited.connect(UIAnimationManager.scale_expand_shake_unhighlight.bind(settings_button))
	
	# Save & Quit Button Animations
	exit_button.mouse_entered.connect(UIAnimationManager.scale_expand_shake_highlight.bind(exit_button))
	exit_button.mouse_exited.connect(UIAnimationManager.scale_expand_shake_unhighlight.bind(exit_button))
