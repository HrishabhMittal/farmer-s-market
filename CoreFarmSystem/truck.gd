extends Area2D

var highlight_shader_material: ShaderMaterial
@export_file("*.tscn") var target_scene_path: String

func _ready():
	add_to_group("interactable")
	
	# Highlight related code
	highlight_shader_material = load("res://shaders/yellow_highlight_shader_material.tres").duplicate()
	highlight_shader_material.set_shader_parameter("enable_outline", false)
	highlight_shader_material.set_shader_parameter("line_scale", 25.0)
	$Sprite2D.material = highlight_shader_material
	$StaticBody2D.mouse_entered.connect(highlight)
	$StaticBody2D.mouse_exited.connect(unhighlight)

func highlight() -> void:
	highlight_shader_material.set_shader_parameter("enable_outline", true)
	
func unhighlight() -> void:
	highlight_shader_material.set_shader_parameter("enable_outline", false)

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
