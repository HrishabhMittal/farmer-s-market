extends VBoxContainer

# Add some good texture pls :p
# Can add phone here too

@export var inventory_button: TextureButton
@export var control_info_button: TextureButton

@export var only_inventory_button_is_active: bool = false

func _ready():
	inventory_button.pressed.connect(_on_inventory_button_pressed)
	inventory_button.mouse_entered.connect(UIAnimationManager.scale_expand_shake_highlight.bind(inventory_button))
	inventory_button.mouse_exited.connect(UIAnimationManager.scale_expand_shake_unhighlight.bind(inventory_button))
	
	if only_inventory_button_is_active: # Will skip other things
		control_info_button.visible = false
		return
		
	control_info_button.pressed.connect(_on_control_info_button_pressed)
	control_info_button.mouse_entered.connect(UIAnimationManager.scale_expand_shake_highlight.bind(control_info_button))
	control_info_button.mouse_exited.connect(UIAnimationManager.scale_expand_shake_unhighlight.bind(control_info_button))
	
	%ControlInfoImage.pivot_offset = size / 2.0
	%ControlInfoImage.offset_transform_enabled = true	
	
func _on_inventory_button_pressed() -> void:
	InventoryManager.player_ui.visible = !InventoryManager.player_ui.visible
	
func _on_control_info_button_pressed() -> void:
	# If it was already visible, then hide it
	if %ControlInfoImage.visible:
		%ControlInfoImage.visible = false
		%ControlInfoImage.offset_transform_scale = Vector2.ONE
		return
	
	%ControlInfoImage.visible = !%ControlInfoImage.visible
	%ControlInfoImage.offset_transform_scale = Vector2.ZERO
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(%ControlInfoImage, "offset_transform_scale", Vector2(1.0, 1.0), 0.25)

func _unhandled_input(event):
	if only_inventory_button_is_active:
		return
	
	if event.is_action_pressed("left click") or\
	   event.is_action_pressed("right click") or\
	   event.is_action("esc"):
		%ControlInfoImage.visible = false
		%ControlInfoImage.offset_transform_scale = Vector2.ONE
