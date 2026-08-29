# The design of the slot that is used in the InventoryUI

extends Control
class_name SlotUI

@export var slot_texture_node: TextureRect
@export var slot_label_node: Label

var connected_inventory: Inventory
var slot_index: int
var current_item: Item
var marked_as_seed_slot: bool = false
var current_inspection_ui: SeedInspectionUI

func _ready():
	gui_input.connect(_handle_gui_input)
	
	slot_texture_node.pivot_offset = size / 2.0 # Needed for proper highlighting
	slot_texture_node.offset_transform_enabled = true # Needed for proper highlighting
	mouse_entered.connect(_highlight)
	mouse_exited.connect(_unhilight)
	
	if marked_as_seed_slot:
		SignalBus.player_picked_seed.connect(start_glow)
		SignalBus.player_dropped_seed.connect(stop_glow)
		
		pivot_offset = size / 2.0
		offset_transform_enabled = true

func refresh_slot(item: Item) -> void:
	if item:
		current_item = item
		slot_texture_node.texture = item.item_data.item_texture
		slot_label_node.text = str(item.amount)
	else:
		current_item = null
		slot_texture_node.texture = null
		slot_label_node.text = ""
	#prints("current_item = ", current_item)

func _handle_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_inventory_transfer"):
		if connected_inventory.is_quick_transfer_allowed:
			InventoryManager.quick_transfer_item(self)
		accept_event()
	
	if event.is_action_pressed("right click"):
		# Only allowed when there is no item on mouse pointer
		if not current_item or not PlayerHeldItem.is_empty():
			return
		
		# Show stack split prompt
		InfocardManager.show_stack_split_ui(self)
	
	# Actually it can be used to inspect any item
	if event.is_action_pressed("inspect_item_inventory"):
		if current_inspection_ui:
			current_inspection_ui.end_inspection() # Remvoe previously open inspection window is it was there
		
		if current_item:
			current_inspection_ui = InfocardManager.show_seed_inspection_ui(current_item)
	
	if event.is_action_pressed("left click"):
		accept_event()
		if connected_inventory == StateManager.active_seed_inventory and PlayerHeldItem.is_empty():
			var current_scene = get_tree().current_scene
			if current_scene and current_scene.has_method("select_seed_slot"):
				
				if current_scene.tool_manager.selected_tool == 3:
					if current_item != null:
						PlayerHeldItem.pick_item(current_item, self)
						return
						
				current_scene.select_seed_slot()
			return
		PlayerHeldItem.pick_item(current_item, self)
		
	if event.is_action_pressed("right click"):
		accept_event()
		if connected_inventory == StateManager.active_seed_inventory and PlayerHeldItem.is_empty():
			PlayerHeldItem.pick_item(current_item, self)

func _highlight() -> void:
	if not current_item:
		return
		
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(slot_texture_node, "offset_transform_scale", Vector2(1.2, 1.2), 0.1)

	AudioManager.play_sfx("item hover sfx")
	InfocardManager.show_infocard(current_item)
	
func _unhilight() -> void:
	if not current_item:
		return
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(slot_texture_node, "offset_transform_scale", Vector2(1.0, 1.0), 0.1)
	
	InfocardManager.hide_infocard()
	if current_inspection_ui:
		current_inspection_ui.end_inspection()
		current_inspection_ui = null

# Glow - Just for seed slot for now
@export var glow_color: Color = Color(2.0, 0.7, 0.4, 1.0)
var min_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var glow_scale := Vector2(1.3, 1.3)
var duration: float = 0.5

var glow_tween: Tween

func start_glow() -> void:
	if glow_tween and glow_tween.is_running():
		glow_tween.kill()

	glow_tween = create_tween()
	glow_tween.set_loops()
	glow_tween.set_trans(Tween.TRANS_SINE)
	glow_tween.set_ease(Tween.EASE_IN_OUT)

	glow_tween.tween_property(self, "modulate", glow_color, duration)
	glow_tween.parallel().tween_property(self, "offset_transform_scale", glow_scale, duration)
	
	glow_tween.tween_property(self, "modulate", min_color, duration)
	glow_tween.parallel().tween_property(self, "offset_transform_scale", Vector2.ONE, duration)

func stop_glow() -> void:
	if glow_tween and glow_tween.is_running():
		glow_tween.kill()
	modulate = min_color
	offset_transform_scale = Vector2.ONE
