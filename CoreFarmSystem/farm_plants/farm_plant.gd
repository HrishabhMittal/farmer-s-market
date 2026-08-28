extends Node2D
class_name FarmPlant

var tile_manager: FarmTileManager
@export var display_name: String
@export var plant_texture: TextureRect
@export var produced_crop_id: String
@export var production_amount: int = 1
var growth_cycle_day: Array[int] = [1, 2]
@export var growth_cycle_texture: Array[Texture2D]= [null, null, null]
@export var growth_chance: int = 100

var current_growth_time: int = 0
var current_growth_cycle: int = 0
var is_fully_grown: bool = false

func _ready():
	SignalBus.global_growth_tick.connect(_on_growth_tick)
	plant_texture.gui_input.connect(_handle_harvest_attempt)
	plant_texture.mouse_entered.connect(highlight)
	plant_texture.mouse_exited.connect(unhighlight)
	
	if not is_fully_grown and growth_cycle_texture.size() > current_growth_cycle:
		plant_texture.texture = growth_cycle_texture[current_growth_cycle]

func _on_growth_tick() -> void:
	if is_fully_grown:
		return
		
	var should_grow: bool = randi_range(1, 100) <= growth_chance
	if not should_grow:
		return
		
	if is_watered():
		production_amount += 1
		InfocardManager.show_floating_text("+1", global_position, "Green")
		tile_manager.unwater_tile(global_position)
		
	current_growth_time += 1
	_handle_growth()

func process_missed_ticks(ticks: int) -> void:
	for i in range(ticks):
		if is_fully_grown:
			break
			
		var should_grow: bool = randi_range(1, 100) <= growth_chance
		if not should_grow:
			continue
			
		if is_watered():
			production_amount += 1
			tile_manager.unwater_tile(global_position)
			
		current_growth_time += 1
		_handle_growth()

func _handle_growth() -> void:
	if current_growth_time >= growth_cycle_day[current_growth_cycle]:
		current_growth_cycle += 1
		if growth_cycle_texture.size() > current_growth_cycle:
			plant_texture.texture = growth_cycle_texture[current_growth_cycle]
			
	if current_growth_cycle >= growth_cycle_day.size():
		is_fully_grown = true

func _handle_harvest_attempt(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("left click"):
		if is_fully_grown:
			harvest()
			get_viewport().set_input_as_handled()

func harvest() -> void:
	## Method 1: Add item directly to players inventory, But that will fail if player has full inventory
	#InventoryManager.add_item_to_barn(produced_crop_id, production_amount)
	
	## Method 2: Drop harvested crop on the ground. He can pick it up later if inventory is full so item is not lost
	ItemManager.spawn_ground_item_from_id(produced_crop_id, production_amount, global_position)
	
	SignalBus.crop_harvested.emit(self)
	tile_manager.untill_tile(global_position)
	call_deferred("queue_free")

func is_watered() -> bool:
	return tile_manager.get_tile_type(global_position) == "watered"

func highlight() -> void:
	modulate = Color(1.2, 1.2, 1.2, 1)
	InfocardManager.show_farmplant_infocard(self)

func unhighlight() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1)
	InfocardManager.hide_farmplant_infocard()
