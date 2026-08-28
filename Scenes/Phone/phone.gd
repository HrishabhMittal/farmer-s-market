extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var app_area: Area2D = $Area2D

var current_shop_id: String = ""

func _ready() -> void:
	sprite.hframes = 2 
	
	var current_scene = get_tree().current_scene
	if current_scene and "shop_id" in current_scene:
		current_shop_id = current_scene.shop_id
		
	sprite.frame = 1 if StateManager.police_called_shops.has(current_shop_id) else 0
	app_area.input_event.connect(_on_app_clicked)

func _on_app_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	AudioManager.play_sfx("Farm Police")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if current_shop_id != "" and not StateManager.police_called_shops.has(current_shop_id):
			StateManager.police_called_shops.append(current_shop_id)
			sprite.frame = 1
