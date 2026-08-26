extends Node2D
class_name FarmPlant

var tile_manager: FarmTileManager
@export var display_name: String
@export var plant_texture: TextureRect
@export var produced_crop_id: String
@export var production_amount: int = 1

# Check potato_lant scene to get better idea how it is being initialized
var growth_cycle_day: Array[int] = [1, 2]
@export var growth_cycle_texture: Array[Texture2D]= [null, null, null]
@export var grwoth_chance: int = 100 # In percentage. 50 means 50%
@export var growth_tick: float = 5.0 # In seconds
var current_time: float = 0.0

var current_growth_time: int = 0 # How many days have passed since planting this crop
var current_growth_cycle: int = 0
var is_fully_grown: bool = false

func _physics_process(delta):
	current_time += delta
	if current_time >= growth_tick:
		_on_growth_tick()
		current_time = 0.0

func _ready():
	#SignalBus.day_ended.connect(_on_day_ended)
	plant_texture.gui_input.connect(_handle_harvest_attempt)
	plant_texture.mouse_entered.connect(highlight)
	plant_texture.mouse_exited.connect(unhighlight)
	plant_texture.texture = growth_cycle_texture[0] # Set to first cycle sprite
	
#func _on_day_ended() -> void:
	##prints(tile_manager.get_tile_type(global_position))
	#if not tile_manager.get_tile_type(global_position) == "watered":
		#return
	#
	#current_growht_time += 1
	#tile_manager.unwater_tile(global_position)
	#if not is_fully_grown:
		#_handle_growth()
	
func _on_growth_tick() -> void:
	if is_fully_grown:
		return
	
	var should_grow: bool = randi_range(1, 100) <= grwoth_chance
	if not should_grow:
		return
	
	if is_watered():
		production_amount += 1
		InfocardManager.show_floating_text("+1", global_position, "Green")
		tile_manager.unwater_tile(global_position)
	
	current_growth_time += 1
	_handle_growth()
	
func _handle_growth() -> void:
	if current_growth_time == growth_cycle_day[current_growth_cycle]:
		current_growth_cycle += 1
		plant_texture.texture = growth_cycle_texture[current_growth_cycle]
		
		if current_growth_cycle == growth_cycle_day.size():
			is_fully_grown = true

func _handle_harvest_attempt(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("left click"):
		if is_fully_grown:
			harvest()
			get_viewport().set_input_as_handled()

func harvest() -> void:
	InventoryManager.add_item(produced_crop_id, production_amount)
	SignalBus.crop_harvested.emit(self)
	tile_manager.untill_tile(global_position)
	call_deferred("queue_free")

func is_watered() -> bool:
	if tile_manager.get_tile_type(global_position) == "watered":
		return true
	return false

func highlight() -> void:
	modulate = Color(1.2, 1.2, 1.2, 1)
	InfocardManager.show_farmplant_infocard(self)
	
func unhighlight() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1)
	InfocardManager.hide_farmplant_infocard()
