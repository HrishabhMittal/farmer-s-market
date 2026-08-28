extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# dont have music for this rn
	AudioManager.play_music("Farm Day Alternate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
