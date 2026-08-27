extends Node2D

@export var shop_id: String = "seed_shop_1"
@export var minimised_sheet: Texture2D
@export var maximised_sheet: Texture2D

@onready var shelf = $shelf
@onready var table_marker = $Table
@onready var action_menu = $CanvasLayer/ActionMenu
@onready var inspect_overlay = $CanvasLayer/InspectOverlay
@onready var inspect_sprite = $CanvasLayer/InspectOverlay/InspectSprite

var bag_on_table = null


var seed_item_ids = ["pumpkin_seed", "carrot_seed", "cabbage_seed", "potato_seed", "tomato_seed"]

func _process(delta: float) -> void:
	pass

func _ready():
	add_to_group("shop") 
	add_to_group("save_state")
	if StateManager.seed_shops.has(shop_id):
		load_shop()
	else:
		refresh_shop()
	action_menu.hide()
	inspect_overlay.hide()

func refresh_shop():
	for bag in shelf.get_children():
		var type = randi() % 5
		var is_real = randf() > 0.5
		var fake_var = (randi() % 5) + 1 
		
		bag.setup(type, is_real, fake_var, minimised_sheet)
		bag.return_to_shelf()
		
	bag_on_table = null

func load_shop():
	var bags = shelf.get_children()
	var saved_bags = StateManager.seed_shops[shop_id]
	for i in range(bags.size()):
		var data = saved_bags[i]
		bags[i].setup(data["type"], data["is_real"], data["fake_var"], minimised_sheet)
		bags[i].return_to_shelf()

func _exit_tree() -> void:
	save_state()

func save_state():
	var bag_data = []
	for bag in shelf.get_children():
		bag_data.append({
			"type": bag.seed_type,
			"is_real": bag.is_real,
			"fake_var": bag.fake_variant
		})
	StateManager.seed_shops[shop_id] = bag_data

func handle_bag_click(bag):
	if inspect_overlay.visible:
		return
		
	if not bag.is_on_table:
		if bag_on_table != null:
			bag_on_table.return_to_shelf()
		
		bag_on_table = bag
		var destination = table_marker.global_position + Vector2(0, -30)
		bag.move_to_table(destination)

		action_menu.show()
		var screen_pos = get_viewport().get_canvas_transform() * destination
		action_menu.global_position = screen_pos + Vector2(60, -30)
		
	else:
		bag.return_to_shelf()
		bag_on_table = null
		action_menu.hide()

func _on_buy_button_pressed() -> void:
	var is_confirmed = await ConfirmationDialogue.ask_confirmation("Buy 32 seeds for 50 Coins?")
	if not is_confirmed:
		return
	if bag_on_table:
		var seed_id = seed_item_ids[bag_on_table.seed_type % seed_item_ids.size()]
		var success = InventoryManager.buy_item(seed_id, 50, 32)
		
		if success:
			InfocardManager.show_floating_text("-50 Coins", action_menu.global_position, "Red")
			print("Successfully bought 32 " + seed_id)
		else:
			InfocardManager.show_floating_text("Not enough money!", action_menu.global_position, "Red")
			print("Not enough money!")


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
		if bag_on_table != null:
			action_menu.show()
