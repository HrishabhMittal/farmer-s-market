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


@export var stack_split_ui_scene: PackedScene
func show_stack_split_ui(slot_ui: SlotUI) -> StackSplitUI:
	var new_stack_split_ui: StackSplitUI = stack_split_ui_scene.instantiate()
	add_child(new_stack_split_ui)
	new_stack_split_ui.initialize(slot_ui)
	new_stack_split_ui.global_position = get_viewport().get_mouse_position()
	
	return new_stack_split_ui
	
@export var seed_inspection_ui_scene: PackedScene
func show_seed_inspection_ui(seed: Item) -> SeedInspectionUI:
	var new_ui: SeedInspectionUI = seed_inspection_ui_scene.instantiate()
	add_child(new_ui)
	new_ui.inspect_item(seed)
	return new_ui # Returning because the caller needs to disable it

func _unhandled_input(event):
	if event.is_action_pressed("left click") or\
	event.is_action_pressed("right click") or\
	event.is_action_pressed("esc"):
		hide_infocard()
