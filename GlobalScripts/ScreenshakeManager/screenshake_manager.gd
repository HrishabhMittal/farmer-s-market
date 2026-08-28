extends Node

##screen shake manager

var camera : Camera2D

var max_shake : float = 10.0
var shake_fade : float = 10.0

var _shake_strength : float = 0.0

#function to trigger from other script w/ ScreenshakeManager.trigger_shake(custom_max_shake, custom_shake_fade) 
func trigger_shake(custom_max_shake: float, custom_shake_fade: float) -> void:
	if not camera: return

	max_shake = custom_max_shake
	shake_fade = custom_shake_fade
	_shake_strength = max_shake


func _process(delta: float) -> void:
	if _shake_strength > 0:
		_shake_strength = lerp(_shake_strength, 0.0, shake_fade * delta)
		camera.offset = Vector2(randf_range(-_shake_strength, _shake_strength), randf_range(-_shake_strength, _shake_strength))

func _ready() -> void:
	for child in get_tree().current_scene.get_children():
		if child is Camera2D:
			camera = child
			break

			print(camera.name)
