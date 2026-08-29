extends PanelContainer
class_name FarmTool

@export var display_name: String
@export var tool_type: FarmToolManager.FarmTools
@export var tool_texture: Texture2D
@export var tool_manager: FarmToolManager

@export var selected_stylebox: StyleBoxFlat
@export var unselected_stylebox: StyleBoxFlat

func _ready():
	$TextureRect.texture = tool_texture
	gui_input.connect(_handle_gui_input)
	tool_manager.tool_selected.connect(process_new_tool_selection)
	
	if tool_type == FarmToolManager.FarmTools.SEED_PLANTER:
		PlayerHeldItem.seed_planter = self
		
	mouse_entered.connect(highlight)
	mouse_exited.connect(unhighlight)

func _handle_gui_input(event: InputEvent) -> void:
	if not PlayerHeldItem.is_empty():
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tool_manager.tool_selected.emit(self) # Using signal so that other tools can know when a new tool is being selected

func process_new_tool_selection(new_tool: FarmTool) -> void:
	if new_tool == self:
		select_tool()
	else:
		unselect_tool()

func select_tool() -> void:
	add_theme_stylebox_override("panel", selected_stylebox)
	
func unselect_tool() -> void:
	add_theme_stylebox_override("panel", unselected_stylebox)

func highlight() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)

func unhighlight() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)
