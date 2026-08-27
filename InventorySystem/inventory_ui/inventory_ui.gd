extends CanvasLayer
class_name InventoryUI

# Some inventories might want to open in different position on the screen so that
# it's easier to transfer items
enum InventoryPosition {LEFT, RIGHT, CENTER, BOTTOM_LEFT, BOTTOM_RIGHT, BOTTOM_CENTER}
var inventory_position: InventoryPosition

@export var slot_ui_scene: PackedScene
@export var slot_anchor: GridContainer 

var connected_inventory: Inventory = null
var slots: Array[SlotUI] = []

func initialize(new_connected_inventory: Inventory, new_anchor_position: InventoryPosition = InventoryPosition.LEFT) -> void:
	connected_inventory = new_connected_inventory
	for i in range(connected_inventory.slot_count):
		var new_slot: Control = slot_ui_scene.instantiate()
		slots.append(new_slot)
		slot_anchor.add_child(new_slot)
		
		slots[i].connected_inventory = connected_inventory
		slots[i].slot_index = i
		
	connected_inventory.slot_changed.connect(_on_slot_changed)
	inventory_position = new_anchor_position

func _ready():
	# This function really needs to be called after _ready is called for proprer size and offset calculation
	call_deferred("_handle_position")

func _on_slot_changed(slot_index: int) -> void:
	slots[slot_index].refresh_slot(connected_inventory.slots[slot_index])

func set_inventory_name(new_name: String) -> void:
	$PanelContainer/VBoxContainer/Label.text = new_name

func _handle_position() -> void:
	match inventory_position:
		InventoryPosition.LEFT:
			$PanelContainer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
		InventoryPosition.RIGHT:
			$PanelContainer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
		InventoryPosition.CENTER:
			$PanelContainer.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		InventoryPosition.BOTTOM_LEFT:
			$PanelContainer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
		InventoryPosition.BOTTOM_RIGHT:
			$PanelContainer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
		InventoryPosition.BOTTOM_CENTER:
			$PanelContainer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)

func _unhandled_input(event: InputEvent):
	pass
