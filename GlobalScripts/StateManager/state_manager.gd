extends Node

const SAVE_PATH = "user://farm_save.json"

var police_called_shops: Array = []
var visited_scenes: Dictionary = {}
var replaced_shops: Dictionary = {}
var bank_balance: int = 0
# money and inventory
var money: int = 500
var barn_inventory: Inventory
var player_inventory: Inventory
var active_seed_inventory: Inventory

# minimap
var position_set_once: bool = false
var target_position: Vector2

# shop
var sell_shops: Dictionary = {}
var seed_shops: Dictionary = {}
var seller_appearances: Dictionary = {}

# farm
var farm_tiles: Dictionary = {}
var farm_plants: Array = []
var farm_ground_items: Array = []
var farm_planted_tiles: Dictionary = {}
var last_farm_save_time: float = 0.0

var police_trust_score: int = 1
var shop_is_scammer: Dictionary = {}

func _ready() -> void:
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().call_group("save_state", "save_state")
		save_to_file()
		get_tree().quit()

func save_to_file() -> void:
	var save_dict = {
		"money": money,
		"bank_balance": bank_balance,
		"barn_inventory": _serialize_inventory(barn_inventory),
		"player_inventory": _serialize_inventory(player_inventory),
		"active_seed_inventory": _serialize_inventory(active_seed_inventory),
		"position_set_once": position_set_once,
		"target_position_x": target_position.x,
		"target_position_y": target_position.y,
		"sell_shops": sell_shops,
		"seed_shops": seed_shops,
		"seller_appearances": seller_appearances,
		"police_called_shops": police_called_shops,
		"farm_tiles": farm_tiles,
		"farm_plants": farm_plants,
		"farm_ground_items": farm_ground_items,
		"farm_planted_tiles": _serialize_vector_dict(farm_planted_tiles),
		"last_farm_save_time": last_farm_save_time,
		"police_trust_score": police_trust_score,
		"shop_is_scammer": shop_is_scammer,
		"visited_scenes": visited_scenes,
		"replaced_shops": replaced_shops
	}
	var json_string = JSON.stringify(save_dict)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)

func load_from_file() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var save_dict = JSON.parse_string(file.get_as_text())
	
	if save_dict.is_empty():
		return
	visited_scenes = save_dict.get("visited_scenes", {})
	replaced_shops = save_dict.get("replaced_shops", {})
	money = save_dict.get("money", 500)
	bank_balance = save_dict.get("bank_balance", 0)
	police_trust_score = save_dict.get("police_trust_score", 1)
	shop_is_scammer = save_dict.get("shop_is_scammer", {})
	_deserialize_inventory(barn_inventory, save_dict.get("barn_inventory", []))
	_deserialize_inventory(player_inventory, save_dict.get("player_inventory", []))
	_deserialize_inventory(active_seed_inventory, save_dict.get("active_seed_inventory", []))
	
	position_set_once = save_dict.get("position_set_once", false)
	target_position = Vector2(save_dict.get("target_position_x", 0), save_dict.get("target_position_y", 0))
	sell_shops = save_dict.get("sell_shops", {})
	seed_shops = save_dict.get("seed_shops", {})
	seller_appearances = save_dict.get("seller_appearances", {})
	police_called_shops = save_dict.get("police_called_shops", [])
	farm_tiles = save_dict.get("farm_tiles", {})
	farm_plants = save_dict.get("farm_plants", [])
	farm_ground_items = save_dict.get("farm_ground_items", [])
	farm_planted_tiles = _deserialize_vector_dict(save_dict.get("farm_planted_tiles", {}))
	last_farm_save_time = save_dict.get("last_farm_save_time", 0.0)

func _serialize_inventory(inv: Inventory) -> Array:
	var data = []
	if inv == null:
		return data
	for item in inv.slots:
		if item and item.item_data:
			data.append({"id": item.item_data.item_id, "amount": item.amount})
		else:
			data.append(null)
	return data

func _deserialize_inventory(inv: Inventory, data: Array) -> void:
	if inv == null or data.is_empty():
		return inv.make_empty()
	for i in range(min(data.size(), inv.slot_count)):
		if data[i] != null:
			inv.slots[i] = ItemManager.make_item(data[i]["id"], data[i]["amount"])
			inv.slots[i].update_info(inv, i)

func _serialize_vector_dict(dict: Dictionary) -> Dictionary:
	var result = {}
	for key in dict.keys():
		result[str(key.x) + "," + str(key.y)] = dict[key]
	return result

func _deserialize_vector_dict(dict: Dictionary) -> Dictionary:
	var result = {}
	for key in dict.keys():
		var parts = key.split(",")
		result[Vector2i(int(parts[0]), int(parts[1]))] = dict[key]
	return result


func reset_shops() -> void:
	for arrested_shop_id in police_called_shops:
		if shop_is_scammer.has(arrested_shop_id) and shop_is_scammer[arrested_shop_id]:
			police_trust_score += 1
		else:
			police_trust_score -= 1
			
		seller_appearances.erase(arrested_shop_id)
		
	sell_shops.clear()
	seed_shops.clear()
	shop_is_scammer.clear()
	police_called_shops.clear()

func reset_shops_and_get_feedback() -> Array[String]:
	var feedback: Array[String] = []
	if police_called_shops.size() > 0:
		var scams = 0
		var innocents = 0
		for id in police_called_shops:
			if shop_is_scammer.has(id) and shop_is_scammer[id]:
				scams += 1
				replaced_shops[id] = "scammer"
			else:
				innocents += 1
				replaced_shops[id] = "innocent"
			seller_appearances.erase(id)
			
		if scams > 0 and innocents == 0:
			feedback.append(GameDialogues.POLICE_REPORT_ONLY_SCAMMERS)
		elif innocents > 0 and scams == 0:
			feedback.append(GameDialogues.POLICE_REPORT_ONLY_INNOCENT)
		else:
			feedback.append(GameDialogues.POLICE_REPORT_MIXED)
			
		var net_change = clamp(scams - innocents, -1, 1)
		police_trust_score += net_change
		
		if police_trust_score < 0:
			# Deduct the fine
			money -= GameConfig.fine_amount
			if money < 0:
				money = 0
			feedback.append(GameDialogues.POLICE_TRUST_NEGATIVE)
		elif police_trust_score == 0: 
			feedback.append(GameDialogues.POLICE_TRUST_ZERO)
		elif police_trust_score == 1: 
			feedback.append(GameDialogues.POLICE_TRUST_LOW)
		elif police_trust_score == 2: 
			feedback.append(GameDialogues.POLICE_TRUST_MODERATE)
		else: 
			feedback.append(GameDialogues.POLICE_TRUST_HIGH)
		
	sell_shops.clear()
	seed_shops.clear()
	shop_is_scammer.clear()
	police_called_shops.clear()
	return feedback
