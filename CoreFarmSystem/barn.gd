extends Area2D

var highlight_shader_material: ShaderMaterial

func _ready():
	add_to_group("interactable")
	
	# Highlight related code
	highlight_shader_material = load("res://shaders/yellow_highlight_shader_material.tres").duplicate()
	highlight_shader_material.set_shader_parameter("enable_outline", false)
	$Sprite2D.material = highlight_shader_material
	$StaticBody2D.mouse_entered.connect(highlight)
	$StaticBody2D.mouse_exited.connect(unhighlight)

func interact():
	pass # Disabled click access. Opens automatically when player inventory is opened nearby.

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left click"):
		InventoryManager.toggle_inventory_ui(!InventoryManager.barn_ui.visible)

func highlight() -> void:
	highlight_shader_material.set_shader_parameter("enable_outline", true)
	
func unhighlight() -> void:
	highlight_shader_material.set_shader_parameter("enable_outline", false)
