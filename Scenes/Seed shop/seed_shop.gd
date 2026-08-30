extends Node2D

@export var shop_id: String = "seed_shop_1"
@export var minimised_sheet: Texture2D
@export var maximised_sheet: Texture2D

@onready var shelf = $shelf
@onready var table_marker = $Table
@onready var action_menu = $CanvasLayer/ActionMenu
@onready var inspect_overlay = $CanvasLayer/InspectOverlay
@onready var inspect_sprite = $CanvasLayer/InspectOverlay/InspectSprite

# UI Nodes
@onready var phone = $CanvasLayer/Phone
@onready var phone_icon = $CanvasLayer/PhoneIcon
@onready var book = $CanvasLayer/book
@onready var book_icon = $CanvasLayer/BookIcon

var bag_on_table = null
var seed_item_ids = ["pumpkin_seed", "carrot_seed", "cabbage_seed", "potato_seed", "tomato_seed"]

# Animation Variables
var is_phone_open = false
var is_book_open = false
var phone_original_pos: Vector2
var book_original_pos: Vector2
var phone_icon_pos: Vector2
var book_icon_pos: Vector2

func _ready():
	add_to_group("shop") 
	add_to_group("save_state")
	if has_node("Seller"):
		$Seller.setup(shop_id)
		
	if StateManager.seed_shops.has(shop_id):
		load_shop()
	else:
		refresh_shop()
		
	action_menu.hide()
	inspect_overlay.hide()
	AudioManager.play_music("shop music")
	
	# --- ANIMATION SETUP ---
	phone_original_pos = phone.position
	book_original_pos = book.position
	phone_icon_pos = phone_icon.position
	book_icon_pos = book_icon.position

	# Hide both offscreen initially
	phone.position.y = 1200
	book.position.y = 1200

	phone_icon.pressed.connect(_on_phone_icon_clicked)
	book_icon.pressed.connect(_on_book_icon_clicked)

	phone.close_requested.connect(close_phone)

	if not StateManager.visited_scenes.get("seed_shop", false):
		StateManager.visited_scenes["seed_shop"] = true
		DialogueManager.show_dialog([GameDialogues.MOM_SEED_SHOP], "Mom")
		
	phone_icon.mouse_entered.connect(UIAnimationManager.scale_expand_highlight.bind(phone_icon))
	phone_icon.mouse_exited.connect(UIAnimationManager.scale_expand_unhighlight.bind(phone_icon))

func _on_phone_icon_clicked():
	if is_phone_open: return
	is_phone_open = true
	if is_book_open: close_book() # Prevent overlapping
	
	var tween = create_tween().set_parallel(true)
	# Phone icon slides right and fades out
	tween.tween_property(phone_icon, "position:x", phone_icon_pos.x + 100.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(phone_icon, "modulate:a", 0.0, 0.4)
	tween.tween_property(phone, "position:y", phone_original_pos.y, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_book_icon_clicked():
	if is_book_open: return
	is_book_open = true
	if is_phone_open: close_phone() # Prevent overlapping
	
	var tween = create_tween().set_parallel(true)
	# Book icon slides left and fades out
	tween.tween_property(book_icon, "position:x", book_icon_pos.x - 100.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(book_icon, "modulate:a", 0.0, 0.4)
	tween.tween_property(book, "position:y", book_original_pos.y, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close_phone():
	if not is_phone_open: return
	is_phone_open = false
	var tween = create_tween().set_parallel(true)
	tween.tween_property(phone, "position:y", 1200.0, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(phone_icon, "position:x", phone_icon_pos.x, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(phone_icon, "modulate:a", 1.0, 0.4)

func close_book():
	if not is_book_open: return
	is_book_open = false
	var tween = create_tween().set_parallel(true)
	tween.tween_property(book, "position:y", 1200.0, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(book_icon, "position:x", book_icon_pos.x, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(book_icon, "modulate:a", 1.0, 0.4)

func _unhandled_input(event: InputEvent) -> void:
	# Close the active UI with ESC or Right Click
	if event.is_action_pressed("esc") or event.is_action_pressed("right click"):
		if is_phone_open:
			close_phone()
			get_viewport().set_input_as_handled()
		elif is_book_open:
			close_book()
			get_viewport().set_input_as_handled()


func refresh_shop():
	# Roll to see if THIS seller is a scammer
	var is_scammer = randf() <= GameConfig.scammer_chance
	StateManager.shop_is_scammer[shop_id] = is_scammer

	for bag in shelf.get_children():
		bag.show()
		var type = randi() % 5
		
		# Determine if bag is real based on seller alignment
		var is_real = true
		if is_scammer:
			is_real = randf() > GameConfig.scammer_defective_ratio
			
		var fake_var = (randi() % 4) + 1
		
		# Calculate price variation
		var seed_id = seed_item_ids[type % seed_item_ids.size()]
		var honest_price = GameConfig.all_item_original_prices.get(seed_id, 50)
		var varied_price = int(honest_price * randf_range(GameConfig.minimum_price_ratio, 1.0))
		
		bag.setup(type, is_real, fake_var, varied_price, minimised_sheet)
		bag.return_to_shelf()
		
	bag_on_table = null


func load_shop():
	var bags = shelf.get_children()
	var saved_bags = StateManager.seed_shops[shop_id]
	for i in range(bags.size()):
		if i < saved_bags.size():
			var data = saved_bags[i]
			bags[i].setup(data["type"], data["is_real"], data["fake_var"], data.get("price", 50), minimised_sheet)
			bags[i].show()
			bags[i].return_to_shelf()
		else:
			bags[i].hide()


func save_state():
	var bag_data = []
	for bag in shelf.get_children():
		if bag.visible:
			bag_data.append({
				"type": bag.seed_type,
				"is_real": bag.is_real,
				"fake_var": bag.fake_variant,
				"price": bag.bag_price
			})
	StateManager.seed_shops[shop_id] = bag_data


func handle_bag_click(bag):
	if not bag.visible: return
	if inspect_overlay.visible: return
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

func _exit_tree() -> void:
	save_state()

func _on_buy_button_pressed() -> void:
	if not bag_on_table:
		return
	
	var base_seed_id = seed_item_ids[bag_on_table.seed_type % seed_item_ids.size()]
	var price = bag_on_table.bag_price
	var honest_amount = GameConfig.seeds_per_bag.get(base_seed_id, 32)
	
	var is_confirmed = await ConfirmationDialogue.ask_confirmation("Buy %d seeds for %d Coins?" % [honest_amount, price])
	if not is_confirmed:
		return
	if StateManager.money < price:
		InfocardManager.show_floating_text("Not enough money!", action_menu.global_position, "Red")
		return
	
	var final_seed_id = base_seed_id
	if not bag_on_table.is_real:
		var variant_suffixes = ["", "_barcode", "_chomped", "_spot", "_tear"]
		var suffix = variant_suffixes[clampi(bag_on_table.fake_variant, 1, 4)]
		final_seed_id = base_seed_id + suffix

	var actual_amount = honest_amount
	if not bag_on_table.is_real:
		actual_amount = int(honest_amount * GameConfig.defective_seed_multiplier)
		
	var success = InventoryManager.buy_item(final_seed_id, price, actual_amount)
	if success:
		AudioManager.play_sfx("Buy")
		InfocardManager.show_floating_text("-%d Coins" % price, action_menu.global_position, "Red")
		bag_on_table.hide()
		bag_on_table = null
		action_menu.hide()
	else:
		InfocardManager.show_floating_text("Inventory Full!", action_menu.global_position, "Red")

func _on_inspect_button_pressed() -> void:
	action_menu.hide()
	inspect_overlay.show()
	inspect_sprite.texture = maximised_sheet
	inspect_sprite.hframes = 5
	inspect_sprite.vframes = 5
	if bag_on_table.is_real:
		inspect_sprite.frame = bag_on_table.seed_type * 5
	else:
		inspect_sprite.frame = (bag_on_table.seed_type * 5) + bag_on_table.fake_variant

func _on_inspect_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		inspect_overlay.hide()
		if bag_on_table != null:
			action_menu.show()
