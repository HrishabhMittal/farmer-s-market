extends Node2D
var seed_type: int = 0
var is_real: bool = true
var fake_variant: int = 1
var is_on_table: bool = false

@onready var sprite = $"bag/place holder"
@onready var click_area = $bag/seed_pack

var shelf_position: Vector2
var move_tween: Tween


func _ready():
	shelf_position = global_position
	if not click_area.input_event.is_connected(_on_seed_pack_input_event):
		click_area.input_event.connect(_on_seed_pack_input_event)

func setup(type: int, real: bool, fake_var: int, minimised_texture: Texture2D):
	seed_type = type
	is_real = real
	fake_variant = fake_var
	
	sprite.texture = minimised_texture
	sprite.hframes = 5
	sprite.vframes = 1
	sprite.frame = seed_type

func move_to_table(target_pos: Vector2):
	is_on_table = true
	_animate_to(target_pos)

func return_to_shelf():
	is_on_table = false
	_animate_to(shelf_position)

func _animate_to(target_pos: Vector2):
	if move_tween and move_tween.is_valid():
		move_tween.kill() 
		
	move_tween = create_tween()
	move_tween.tween_property(self, "global_position", target_pos, 0.25)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _on_seed_pack_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var shop = get_tree().get_first_node_in_group("shop")
		if shop:
			shop.handle_bag_click(self)
