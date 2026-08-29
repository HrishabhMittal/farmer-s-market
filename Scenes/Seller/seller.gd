extends Node2D
class_name SellerNPC

@onready var base = $base
@onready var clothes = $clothes
@onready var expression = $expression
@onready var accessory = $accessory

var current_shop_id: String = ""
const CELL_SIZE = 2000

func _ready():
	var area = Area2D.new()
	var coll = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(2000, 2000)
	coll.shape = rect
	area.add_child(coll)
	add_child(area)
	area.input_event.connect(_on_input_event)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var diag = GameDialogues.SHOPKEEPER_GENERIC
		if StateManager.replaced_shops.has(current_shop_id):
			if StateManager.replaced_shops[current_shop_id] == "scammer": diag = GameDialogues.SHOPKEEPER_REPLACED_SCAMMER
			else: diag = GameDialogues.SHOPKEEPER_REPLACED_INNOCENT
		DialogueManager.show_dialog([diag], "Seller")

func setup(shop_id: String) -> void:
	current_shop_id = shop_id
	
	if clothes.texture:
		clothes.hframes = clothes.texture.get_width() / CELL_SIZE
		clothes.vframes = 1
	if expression.texture:
		expression.hframes = expression.texture.get_width() / CELL_SIZE
		expression.vframes = 1
	if accessory.texture:
		accessory.hframes = accessory.texture.get_width() / CELL_SIZE
		accessory.vframes = 1

	if StateManager.seller_appearances.has(current_shop_id):
		_load_appearance()
	else:
		reroll_seller()

func reroll_seller() -> void:
	var appearance = {}

	if clothes.texture:
		appearance["clothes"] = randi() % clothes.hframes
	if expression.texture:
		appearance["expression"] = randi() % expression.hframes
	if accessory.texture:
		appearance["accessory"] = randi() % accessory.hframes
		
	StateManager.seller_appearances[current_shop_id] = appearance
	_load_appearance()

func _load_appearance() -> void:
	var appearance = StateManager.seller_appearances[current_shop_id]
	
	if appearance.has("clothes") and clothes.texture:
		clothes.frame = appearance["clothes"]
	if appearance.has("expression") and expression.texture:
		expression.frame = appearance["expression"]
	if appearance.has("accessory") and accessory.texture:
		accessory.frame = appearance["accessory"]
