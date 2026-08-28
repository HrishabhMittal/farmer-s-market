extends Node

func set_bus_volume(bus_name: String, value_normalized: float) -> void:
	var bus_index:= AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		var db:= linear_to_db(value_normalized)
		AudioServer.set_bus_volume_db(bus_index, db)

func set_display_mode(mode_index: int) -> void:
	match mode_index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
