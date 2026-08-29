extends Node2D

@export var shop_id: String = "sell_shop_1"
@onready var price_label: Label = $CanvasLayer/PriceLabel

# UI Nodes
@onready var phone = $CanvasLayer/Phone
@onready var phone_icon = $CanvasLayer/PhoneIcon

var item_prices: Dictionary = {}

# Animation Variables
var is_phone_open = false
var phone_original_pos: Vector2
var phone_icon_pos: Vector2

func _ready() -> void:
	add_to_group("sell_shop")
	add_to_group("save_state")
	if has_node("Seller"):
		$Seller.setup(shop_id)
	if InventoryManager.player_ui:
		# InventoryManager.player_ui.visible = true # this is kinda annoying ngl
		InventoryManager.player_ui.refresh_inventory()
	if StateManager.sell_shops.has(shop_id):
		item_prices = StateManager.sell_shops[shop_id].duplicate()
		update_price_label()
	else:
		refresh_shop()
		
	AudioManager.play_music("shop music")
	
	# --- ANIMATION SETUP ---
	phone_original_pos = phone.position
	phone_icon_pos = phone_icon.position
	# Hide the phone offscreen at the bottom
	phone.position.y = 1200 
	phone_icon.pressed.connect(_on_phone_icon_clicked)
	
	phone.close_requested.connect(close_phone)
	
	if not StateManager.visited_scenes.get("sell_shop", false):
		StateManager.visited_scenes["sell_shop"] = true
		DialogueManager.show_dialog([GameDialogues.MOM_SELL_SHOP], "Mom")

func _on_phone_icon_clicked():
	if is_phone_open: return
	is_phone_open = true
	
	var tween = create_tween().set_parallel(true)
	# Icon slides right and fades out
	tween.tween_property(phone_icon, "position:x", phone_icon_pos.x + 100.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(phone_icon, "modulate:a", 0.0, 0.4)
	# Phone pops up from bottom
	tween.tween_property(phone, "position:y", phone_original_pos.y, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close_phone():
	if not is_phone_open: return
	is_phone_open = false
	
	var tween = create_tween().set_parallel(true)
	# Phone slides back down
	tween.tween_property(phone, "position:y", 1200.0, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# Icon slides back to original position and fades in
	tween.tween_property(phone_icon, "position:x", phone_icon_pos.x, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(phone_icon, "modulate:a", 1.0, 0.4)

func _unhandled_input(event: InputEvent) -> void:
	# Close the phone with ESC or Right Click
	if event.is_action_pressed("esc") or event.is_action_pressed("right click"):
		if is_phone_open:
			close_phone()
			get_viewport().set_input_as_handled()
			return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if PlayerHeldItem and not PlayerHeldItem.is_empty():
			var held_item = PlayerHeldItem.get_held_item()
			if held_item and held_item.item_data:
				if ItemTypes.ItemType.VEGETABLE in held_item.item_data.item_type:
					var is_confirmed = await ConfirmationDialogue.ask_confirmation("Sell?")
					if is_confirmed:
						var item_id = held_item.item_data.item_id
						var unit_price = item_prices.get(item_id, held_item.item_data.value)
						var total_sale = unit_price * held_item.amount
						StateManager.money += total_sale
						AudioManager.play_sfx("Sell")
						if InfocardManager:
							InfocardManager.show_floating_text("+%d Coins" % total_sale, get_global_mouse_position(), "Green")
						PlayerHeldItem.clear_item()
				else:
					if InfocardManager:
						InfocardManager.show_floating_text("Can only sell crops!", get_global_mouse_position(), "Red")
					get_viewport().set_input_as_handled()

func _exit_tree() -> void:
	save_state()

func save_state() -> void:
	StateManager.sell_shops[shop_id] = item_prices.duplicate()

func refresh_shop() -> void:
	item_prices.clear()
	var is_scammer = randf() <= GameConfig.scammer_chance
	StateManager.shop_is_scammer[shop_id] = is_scammer
	
	if ItemManager and ItemManager.all_items:
		for item_id in ItemManager.all_items.keys():
			var item_data = ItemManager.get_item(item_id)
			if item_data and ItemTypes.ItemType.VEGETABLE in item_data.item_type:
				var honest_price = GameConfig.all_item_original_prices.get(item_id, item_data.value)
				var varied_price = honest_price * randf_range(GameConfig.minimum_price_ratio, 1.0)
				
				if is_scammer:
					varied_price *= GameConfig.scam_seller_lowball
					
				item_prices[item_id] = int(varied_price)
				
	update_price_label()
func update_price_label() -> void:
	if not price_label: return
	var text = "Current Market Prices\n"
	for item_id in item_prices.keys():
		var display_name = ItemManager.get_item(item_id).display_name
		text += "%s: %d Coins\n" % [display_name, item_prices[item_id]]
	price_label.text = text
