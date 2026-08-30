# When player picks up item from inventory by clicking on it, this scene will manage showing that
# and also moving it to other slots and inventories

extends Node2D

@export var texture_node: TextureRect
@export var label_node: Label
@export var show_item_on_mouse: bool = true
@export var allow_farm_plot_highlight: bool = true

var seed_planter: FarmTool # Will be initialized by the tool itself
var farm_tilemanager: FarmTileManager

var mouse_inventory: Inventory
var is_currently_showing: bool # If player is holding a item then it will be shown at mouse pointer if this variable is true

func _ready():
	mouse_inventory = Inventory.new(1, false)
	SignalBus.farm_tilemanager_ready.connect(_on_farmtilemanager_ready)
	if allow_farm_plot_highlight:
		%TileHighlight.visible = false

func _on_farmtilemanager_ready(new_tilemanager: FarmTileManager) -> void:
	farm_tilemanager = new_tilemanager

func pick_item(item: Item, source_slot: SlotUI, is_stack_splitting: bool = false) -> void:
	if is_stack_splitting: # When mouse is picking item from a stack spliting operation
		mouse_inventory.add_item(item, item.amount)
		#if source_slot.current_item.amount <= 0:
			#source_slot.refresh_slot(null)
		_show_item_on_mouse()
		return
	
	if InventoryManager.is_same_item(item, get_held_item()):
		var held = get_held_item()
		var success = source_slot.connected_inventory.add_item(held, held.amount)
		if success or held.amount <= 0:
			clear_item()
			
	else:
		InventoryManager.swap_item(source_slot.connected_inventory, mouse_inventory, source_slot.slot_index, 0)
		
	_show_item_on_mouse()
	
	#prints(is_held_item_seed())
	if is_held_item_seed():
		if is_instance_valid(seed_planter):
			seed_planter.tool_manager.tool_selected.emit(seed_planter)
		SignalBus.player_picked_seed.emit()
	else:
		SignalBus.player_dropped_seed.emit()


func remove_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	
	var result: bool = mouse_inventory.remove_item(new_item, amount)
	if result:
		_show_item_on_mouse()
	
	if is_empty():
		_hide_item_on_mouse()
	
	return result

# A shortcut version of "remove_item" function to consume given amount from the held item
func consume_item(amount: int = 1) -> bool:
	if not is_empty():
		return remove_item(get_held_item_id(), amount)
	return false

func has_item(item_id: String, amount: int = 0) -> bool:
	var new_item: Item = _make_item(item_id, amount)
	if not new_item:
		push_error("There is no item named", item_id)
		return false
	return mouse_inventory.does_have_item(new_item, amount)

func _make_item(item_id: String, amount: int = 0) -> Item:
	return Item.new(ItemManager.get_item(item_id), amount)

func clear_item() -> void:
	if is_held_item_seed():
		SignalBus.player_dropped_seed.emit()
	
	mouse_inventory.make_empty()
	_hide_item_on_mouse()

func is_empty() -> bool:
	return mouse_inventory.is_empty()

# Returns the item on the mouse cursor
func get_held_item_id() -> String:
	return mouse_inventory.slots[0].item_data.item_id

func get_held_item() -> Item:
	return mouse_inventory.slots[0]

# Shows the current item that player has picked on the mouse pointer
func _show_item_on_mouse() -> void:
	if mouse_inventory.is_empty():
		_hide_item_on_mouse()
		return
	#mouse_inventory.print_inventory()
	#prints(mouse_inventory.slots[0].item_data.item_texture)

	texture_node.texture = mouse_inventory.slots[0].item_data.item_texture
	label_node.text = str(mouse_inventory.slots[0].amount)
	is_currently_showing = true
	
func _hide_item_on_mouse() -> void:
	texture_node.texture = null
	label_node.text = ""
	is_currently_showing = false
	
func _process(_delta):
	if is_currently_showing:
		$CanvasLayer/ItemView.position = get_viewport().get_mouse_position()
		
	if allow_farm_plot_highlight and farm_tilemanager:
		var mouse_pos := get_global_mouse_position()
		var tile_under_mouse: String = farm_tilemanager.get_tile_type(mouse_pos)
		
		if tile_under_mouse != "none":
			%TileHighlight.visible = true
			
			$CanvasLayer2.transform = get_viewport().get_canvas_transform()
			
			%TileHighlight.position = farm_tilemanager.get_tile_center_coord(mouse_pos)
		else:
			%TileHighlight.visible = false
	else:
		if %TileHighlight:
			%TileHighlight.visible = false

func is_held_item_seed() -> bool:
	if is_empty():
		return false
	if ItemTypes.ItemType.SEED in mouse_inventory.slots[0].item_data.item_type:
		return true
	return false
