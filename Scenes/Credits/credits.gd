extends Control

var is_exiting: bool = false

func _ready() -> void:
	AudioManager.play_music("Credits Song")

func _input(event: InputEvent) -> void:
	if is_exiting:
		return
	var is_mouse_click = event is InputEventMouseButton and event.pressed
	
	if is_mouse_click:
		is_exiting = true
		AudioManager.play_music("Farm Day Alternate")
		TravelTransition.change_scene("res://Scenes/MainMenu/main_menu.tscn")
