extends Node2D
var seed_type: int = 0
var is_real: bool = true
var fake_variant: int = 1
var is_on_table: bool = false

@onready var sprite = $"bag/place holder"
@onready var click_area = $bag/seed_pack

var shelf_position: Vector2

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

func return_to_shelf():
	is_on_table = false
	global_position = shelf_position

func _on_seed_pack_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var shop = get_tree().get_first_node_in_group("shop")
		if shop:
			shop.handle_bag_click(self)
