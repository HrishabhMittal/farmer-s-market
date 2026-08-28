extends Area2D

func _ready():
	add_to_group("interactable")

func interact():
	pass # Disabled click access. Opens automatically when player inventory is opened nearby.

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	pass
