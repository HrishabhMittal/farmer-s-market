extends Node2D
var mouse_in = false
var drag = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left click") and mouse_in == true:
		drag = true
	if Input.is_action_just_released("left click") and mouse_in == true:
		drag = false

	if drag == true:
		global_position = get_global_mouse_position()
	else:
		pass

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false

func seed_pack():
	pass
