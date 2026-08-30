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
var is_hovered: bool = false

func _ready():
	if GameConfig.crop_growth_chances.has(produced_crop_id):
		growth_chance = GameConfig.crop_growth_chances[produced_crop_id]
	SignalBus.global_growth_tick.connect(_on_growth_tick)
	
	var base_seed_id = produced_crop_id + "_seed"
	if production_amount <= 1 and GameConfig.crop_seed_yields.has(base_seed_id):
		production_amount = GameConfig.crop_seed_yields[base_seed_id]
		
	plant_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not is_fully_grown and growth_cycle_texture.size() > current_growth_cycle:
		plant_texture.texture = growth_cycle_texture[current_growth_cycle]
		
	recalculate_grow_bar_position()
	%GrowBar.max_value = int(GameConfig.TICK_SPEED)
	%GrowBar.value = int(SignalBus.tick_timer.wait_time - SignalBus.tick_timer.time_left)
	SignalBus.one_second_timer.timeout.connect(update_growth_bar)
	
	hide_growbar()
	#plant_texture.mouse_entered.connect(show_growbar)
	#plant_texture.mouse_exited.connect(hide_growbar) 
	
func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var rect = Rect2(global_position + plant_texture.position, plant_texture.size)
	var currently_hovered = rect.has_point(mouse_pos)
	
	if currently_hovered and not is_hovered:
		highlight()
	elif not currently_hovered and is_hovered:
		unhighlight()

	if is_hovered and is_fully_grown:
		if Input.is_action_pressed("left click") or Input.is_action_pressed("interact"):
			harvest()

func _unhandled_input(event: InputEvent) -> void:
	if is_hovered and is_fully_grown:
		if event.is_action_pressed("interact") or event.is_action_pressed("left click"):
			harvest()
			get_viewport().set_input_as_handled()

func _on_growth_tick() -> void:
	if is_fully_grown:
		return
	
	var should_grow: bool = randi_range(1, 100) <= growth_chance
	if not should_grow:
		InfocardManager.show_floating_text("Need more time!", global_position, "Blue", 15, 5.0, 15)
		return
		
	if is_watered():
		production_amount += 1
		InfocardManager.show_floating_text("+1", global_position, "Green")
		tile_manager.unwater_tile(global_position)
		current_growth_time += 1
		_handle_growth()
	InfocardManager.show_floating_text("Water pls!", global_position, "Red", 15, 5.0, 15)

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
	
	recalculate_grow_bar_position()

func harvest() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var interact_area = player.get_node_or_null("InteractRadius")
		if interact_area:
			var col_shape = interact_area.get_node_or_null("CollisionShape2D")
			if col_shape:
				var max_distance = col_shape.shape.radius
				if player.global_position.distance_to(global_position) > max_distance:
					return
	ItemManager.spawn_ground_item_from_id(produced_crop_id, production_amount, global_position)
	SignalBus.crop_harvested.emit(self)
	tile_manager.untill_tile(global_position)
	InfocardManager.hide_farmplant_infocard() 
	call_deferred("queue_free")

func is_watered() -> bool:
	return tile_manager.get_tile_type(global_position) == "watered"

func highlight() -> void:
	modulate = Color(1.2, 1.2, 1.2, 1)
	InfocardManager.show_farmplant_infocard(self)
	is_hovered = true
	show_growbar()

func unhighlight() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1)
	InfocardManager.hide_farmplant_infocard()
	is_hovered = false
	hide_growbar()

func recalculate_grow_bar_position() -> void:
	await get_tree().process_frame
	
	var texture_top_center: Vector2 = $TextureRect.global_position + Vector2($TextureRect.size.x/2, 0) - Vector2(32, 32)
	%GrowBar.global_position = texture_top_center

func update_growth_bar() -> void:
	if is_fully_grown:
		%GrowBar.value = %GrowBar.max_value
		SignalBus.one_second_timer.timeout.disconnect(update_growth_bar)
		return
	
	if %GrowBar.value == %GrowBar.max_value:
		%GrowBar.value = int(SignalBus.tick_timer.wait_time - SignalBus.tick_timer.time_left)
	
	%GrowBar.value += 1

func show_growbar() -> void:
	%GrowBar.visible = true

func hide_growbar() -> void:
	%GrowBar.visible = false

# Generates a display name based on the seed quality
func generate_display_name(seed_item: Item) -> void:
	var seed_name: String = seed_item.item_data.item_id
	var name_prefix: String = ""
	
	if "barcode" in seed_name:
		name_prefix = "Healthy "
	elif "chomped" in seed_name:
		name_prefix = "Sad "
	elif "spot" in seed_name:
		name_prefix = "Sickly "
	elif "tear" in seed_name:
		name_prefix = "Malnourished "
	else:
		name_prefix = "Glowing "
		
	display_name = name_prefix + display_name
