extends CanvasLayer

@onready var panel: Panel = $Panel

@onready var return_btn = %ReturnButton
@onready var credits_btn = %CreditsButton
@onready var save_quit_btn = %SaveQuitButton

var is_open: bool = false
var menu_tween: Tween

func _ready() -> void:
	panel.position.y = -get_viewport().get_visible_rect().size.y
	
	return_btn.pressed.connect(_on_return_pressed)
	credits_btn.pressed.connect(_on_credits_pressed)
	save_quit_btn.pressed.connect(_on_save_quit_pressed)

func _on_return_pressed() -> void:
	toggle_settings()
	
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.name != "main_menu":
		get_tree().call_group("save_state", "save_state")
		if StateManager:
			StateManager.save_to_file()
		TravelTransition.change_scene("res://Scenes/MainMenu/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		toggle_settings()

func toggle_settings() -> void:
	is_open = !is_open
	update_panel_visiblity(is_open)
	if not is_open:
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()

func update_panel_visiblity(direction: bool) -> void:
	if menu_tween and menu_tween.is_valid():
		menu_tween.kill()
		
	menu_tween = create_tween()
	menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK) 
	
	var viewport_height = get_viewport().get_visible_rect().size.y
	
	if direction:
		menu_tween.tween_property(panel, "position:y", 0.0, 0.4)
	else:
		menu_tween.tween_property(panel, "position:y", -viewport_height, 0.4)

func _on_credits_pressed() -> void:
	toggle_settings() 
	get_tree().call_group("save_state", "save_state")
	if StateManager:
		StateManager.save_to_file()
	get_tree().change_scene_to_file("res://Scenes/Credits/credits.tscn")
func _on_save_quit_pressed() -> void:
	get_tree().call_group("save_state", "save_state")
	if StateManager:
		StateManager.save_to_file()
	get_tree().quit()
