extends Area2D

func _ready():
	add_to_group("interactable")

func interact():
	InventoryManager.truck_ui.visible = false
	InventoryManager.barn_ui.visible = !InventoryManager.barn_ui.visible


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			var interact_radius = player.get_node_or_null("InteractRadius")
			# Verify the Barn is currently inside the Player's InteractRadius
			if interact_radius and interact_radius.is_in_radius(self):
				interact()
			else:
				print("Too far")
