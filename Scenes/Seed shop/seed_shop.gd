extends Node2D

@export var minimised_sheet: Texture2D
@export var maximised_sheet: Texture2D

@onready var shelf = $shelf
@onready var table_marker = $Table
@onready var action_menu = $CanvasLayer/ActionMenu
@onready var inspect_overlay = $CanvasLayer/InspectOverlay
@onready var inspect_sprite = $CanvasLayer/InspectOverlay/InspectSprite

var bag_on_table = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _ready():
	add_to_group("shop") 
	refresh_shop()

func refresh_shop():
	for bag in shelf.get_children():
		var type = randi() % 5
		var is_real = randf() > 0.5
		var fake_var = (randi() % 5) + 1 
		
		bag.setup(type, is_real, fake_var, minimised_sheet)
		bag.return_to_shelf()
		
	bag_on_table = null
	action_menu.hide()
	inspect_overlay.hide()
func handle_bag_click(bag):
	if inspect_overlay.visible:
		return
		
	if not bag.is_on_table:
		if bag_on_table != null:
			bag_on_table.return_to_shelf()
		
		bag_on_table = bag
		bag.is_on_table = true
		bag.global_position = table_marker.global_position + Vector2(0, -30)
		
		action_menu.show()
		var screen_pos = get_viewport().get_canvas_transform() * bag.global_position
		action_menu.global_position = screen_pos + Vector2(60, -30)
		
	else:
		bag.return_to_shelf()
		bag_on_table = null
		action_menu.hide()

func _on_buy_button_pressed() -> void:
	pass # Replace with function body.


func _on_inspect_button_pressed() -> void:
	action_menu.hide()
	inspect_overlay.show()
	
	inspect_sprite.texture = maximised_sheet
	inspect_sprite.hframes = 6
	inspect_sprite.vframes = 5
	
	if bag_on_table.is_real:
		inspect_sprite.frame = bag_on_table.seed_type * 6 
	else:
		inspect_sprite.frame = (bag_on_table.seed_type * 6) + bag_on_table.fake_variant


func _on_inspect_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		inspect_overlay.hide()
