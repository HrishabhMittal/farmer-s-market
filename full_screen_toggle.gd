extends OptionButton
class_name FullScreenToggle

func _ready() -> void:
	clear()
	add_item("Window", 0)
	add_item("Full screen", 1)

	var current_mode:= DisplayServer.window_get_mode()
	select(0 if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN else 1)

	item_selected.connect(_item_selected)

func _item_selected(index: int) -> void:
	SettingManager.set_display_mode(index)
