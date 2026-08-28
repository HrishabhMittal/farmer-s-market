extends AudioStreamPlayer
class_name SFXPlayer

var from_position: float = 0.0

func _ready() -> void:
	finished.connect(queue_free)
	play(from_position)
