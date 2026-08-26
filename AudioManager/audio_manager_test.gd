extends Node2D

@export var test_one_shot_audio: AudioStream

func _ready() -> void:
	AudioManager.play_audio("FarmDay")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		AudioManager.play_one_shot_audio(test_one_shot_audio, -15)
