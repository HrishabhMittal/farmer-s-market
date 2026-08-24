# This is the scene that displays the invenotry in the game
# It pulls data from the inventory resource that is connected with it

extends CanvasLayer
class_name InventoryUI

@export var slot_ui_scene: PackedScene
@export var slot_anchor: GridContainer # New slots will be added to this node as child

var connected_inventory: Inventory = null
var slots: Array[SlotUI] = []

# After instanciating, need to initialize it beofre use
func initialize(new_connected_inventory: Inventory) -> void:
	connected_inventory = new_connected_inventory
	
	for i in range(connected_inventory.slot_count):
		var new_slot: Control = slot_ui_scene.instantiate()
		slots.append(new_slot)
		slot_anchor.add_child(new_slot)
		
		# Update some info data of the slot
		slots[i].connected_inventory = connected_inventory
		slots[i].slot_index = i
		
	connected_inventory.slot_changed.connect(_on_slot_changed)

func _on_slot_changed(slot_index: int) -> void:
	slots[slot_index].refresh_slot(connected_inventory.slots[slot_index])
