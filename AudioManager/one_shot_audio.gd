extends AudioStreamPlayer
class_name OneShotAudio

var from_position: float = 0.0

func _ready() -> void:
	finished.connect(queue_free)
	play(from_position)
