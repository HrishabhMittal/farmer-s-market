extends Area2D

var nearby_interactables: Array = []

func _ready():
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable"):
		nearby_interactables.append(area)


func _on_area_exited(area: Area2D) -> void:
	nearby_interactables.erase(area)

func is_in_radius(area: Area2D) -> bool:
	return nearby_interactables.has(area)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if nearby_interactables.size() > 0:
			if nearby_interactables[0].has_method("interact"):
				nearby_interactables[0].interact()
		else:
			InventoryManager.barn_ui.visible = false
			InventoryManager.truck_ui.visible = false
