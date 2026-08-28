extends Area2D

@export_file("*.tscn") var target_scene_path: String

func _ready():
	add_to_group("interactable")


func interact():
	var is_confirmed = await ConfirmationDialogue.ask_confirmation("Return to town?")
	if not is_confirmed:
		return
		
	if target_scene_path != "":
		InventoryManager.close_all_uis()
		TravelTransition.change_scene(target_scene_path)
	else:
		push_error("no target path scene")


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			var interact_radius = player.get_node_or_null("InteractRadius")
			if interact_radius and interact_radius.is_in_radius(self):
				interact()
			else:
				if InfocardManager:
					InfocardManager.show_floating_text("Too far to leave!", get_global_mouse_position(), "Red")
