extends Area2D
var mouse_in = false
var book_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# toggles book on and off 
	if Input.is_action_just_pressed("left click") and mouse_in == true:
		if book_open == false:
			book_open = true
		elif book_open == true:
			book_open = false
	
	if book_open == true:
		$temporary.visible = true
	elif book_open == false:
		$temporary.visible = false


func _on_mouse_entered() -> void:
	mouse_in = true
func _on_mouse_exited() -> void:
	mouse_in = false
