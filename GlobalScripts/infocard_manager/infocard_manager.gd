extends CanvasLayer

func show_infocard(item: Item) -> void:
	%InventoryItemInfocard.show_infocard(item)

func hide_infocard() -> void:
	%InventoryItemInfocard.hide_infocard()

func show_farmplant_infocard(farmplant: FarmPlant) -> void:
	%FarmplantInfocard.show_infocard(farmplant)

func hide_farmplant_infocard() -> void:
	%FarmplantInfocard.hide_infocard()

@export var floating_text_scene: PackedScene

func show_floating_text(text: String, text_position: Vector2, text_color: String = "Green") -> void:
	var new_floating_text := floating_text_scene.instantiate()
	new_floating_text.initialize(text, text_color)
	
	var screen_pos = get_viewport().get_canvas_transform() * text_position # Needs to adjust for the zoom because the root is a canvaslayer
	new_floating_text.global_position = screen_pos
	
	add_child(new_floating_text)
	new_floating_text.animate()
