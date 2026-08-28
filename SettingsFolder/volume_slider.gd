extends HSlider
class_name VolumeSlider

@export var audio_bus_name: String = "Master"

func _ready() -> void:
	min_value = 0.0
	max_value = 1.0
	step = 0.05

	var bus_index:= AudioServer.get_bus_index(audio_bus_name)
	if bus_index != -1:
		value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float) -> void:
	SettingManager.set_bus_volume(audio_bus_name, new_value)
