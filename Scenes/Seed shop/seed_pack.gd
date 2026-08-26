extends Area2D

var mouse_in = false
var drag = false
@export var on_table = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left click") and mouse_in == true:
		drag = true
	if Input.is_action_just_released("left click") and mouse_in == true:
		drag = false

	if drag == true:
		$"..".global_position = get_global_mouse_position()
	elif drag == false:
		if on_table == false:
			$"..".global_position = $"../../spawn point".global_position
		elif on_table == true:
			pass


func _on_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false
