# The design of the slot that is used in the InventoryUI

extends Control
class_name SlotUI

@export var slot_texture_node: TextureRect
@export var slot_label_node: Label

var connected_inventory: Inventory
var slot_index: int
var current_item: Item

func _ready():
	gui_input.connect(_handle_gui_input)
	
	slot_texture_node.pivot_offset = size / 2.0 # Needed for proper highlighting
	slot_texture_node.offset_transform_enabled = true # Needed for proper highlighting
	mouse_entered.connect(_highlight)
	mouse_exited.connect(_unhilight)

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
