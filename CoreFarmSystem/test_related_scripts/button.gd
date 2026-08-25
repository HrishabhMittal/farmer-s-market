extends Button

func _ready():
	pressed.connect(_progress_day)
	
func _progress_day() -> void:
	SignalBus.day_ended.emit()
