extends Area2D
var mouse_in = false
var drag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# checking if mouse is holding the sprite
	if Input.is_action_just_pressed("left click") and mouse_in == true:
		drag =  true
	if Input.is_action_just_released("left click") and mouse_in == true:
		drag =  false
	#draging system
	if drag == true:
		$".".global_position = get_global_mouse_position()
	elif drag == false:
		pass

func _on_mouse_entered() -> void:
	mouse_in = true
func _on_mouse_exited() -> void:
	mouse_in = false

func seed_pack():
	pass



func _on_table_body_entered(body: Node2D) -> void:
	print("inn")
