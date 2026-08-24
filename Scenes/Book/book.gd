extends Control

# a simple 2d book
# uses tweens to give an illusion of a book,
# might need to make this 3d later
# for now this is fine ig


# this needs to also contain front and back covers
@export var pages: Array[Texture2D] = []

@onready var left_page = $LeftPage
@onready var right_page = $RightPage
@onready var flip_container = $FlipContainer
@onready var flip_front = $FlipContainer/FlipFront
@onready var flip_back = $FlipContainer/FlipBack

var current_left_index = -1
var is_flipping = false

# right now it sets up the book size according to the size of texture
# this function might need to be changed later
func _setup_geometry():
	if pages.size() == 0 or pages[0] == null:
		return
	var page_size: Vector2 = pages[0].get_size()
	custom_minimum_size = Vector2(page_size.x * 2, page_size.y)
	size = custom_minimum_size
	left_page.size = page_size
	left_page.position = Vector2(0, 0)
	right_page.size = page_size
	right_page.position = Vector2(page_size.x, 0)
	flip_container.size = page_size
	flip_container.position = Vector2(page_size.x, 0)
	flip_container.pivot_offset = Vector2(0, 0)
	flip_front.size = page_size
	flip_front.position = Vector2(0, 0)
	flip_back.size = page_size
	flip_back.position = Vector2(0, 0)
	flip_back.flip_h = true

func _ready() -> void:
	flip_container.visible = false
	_setup_geometry()
	update_static_pages()
	left_page.mouse_filter = Control.MOUSE_FILTER_STOP
	right_page.mouse_filter = Control.MOUSE_FILTER_STOP
	left_page.gui_input.connect(_on_left_page_input)
	right_page.gui_input.connect(_on_right_page_input)

func _on_left_page_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		turn_prev()

func _on_right_page_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		turn_next()


func _process(delta: float) -> void:
	pass

func get_texture_at(index: int) -> Texture2D:
	if index >= 0 and index < pages.size():
		return pages[index]
	return null

func update_static_pages():
	left_page.texture = get_texture_at(current_left_index)
	right_page.texture = get_texture_at(current_left_index + 1)

# PAGE TURNING STUFF

func turn_next():
	if is_flipping or current_left_index + 2 >= pages.size():
		return
	is_flipping = true
	flip_front.texture = get_texture_at(current_left_index + 1)
	flip_back.texture = get_texture_at(current_left_index + 2)
	right_page.texture = get_texture_at(current_left_index + 3)
	flip_container.scale.x = 1.0
	flip_container.visible = true
	flip_front.visible = true
	flip_back.visible = false
	var tween = create_tween()
	tween.tween_property(flip_container, "scale:x", 0.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(func():
		flip_front.visible = false
		flip_back.visible = true
	)
	tween.tween_property(flip_container, "scale:x", -1.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(func():
		current_left_index += 2
		update_static_pages()
		flip_container.visible = false
		is_flipping = false
	)

func turn_prev():
	if is_flipping or current_left_index < 0:
		return
	is_flipping = true
	flip_back.texture = get_texture_at(current_left_index)
	flip_front.texture = get_texture_at(current_left_index - 1)
	left_page.texture = get_texture_at(current_left_index - 2)
	flip_container.scale.x = -1.0
	flip_container.visible = true
	flip_front.visible = false
	flip_back.visible = true
	var tween = create_tween()
	tween.tween_property(flip_container, "scale:x", 0.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(func():
		flip_front.visible = true
		flip_back.visible = false
	)
	tween.tween_property(flip_container, "scale:x", 1.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func():
		current_left_index -= 2
		update_static_pages()
		flip_container.visible = false
		is_flipping = false
	)
