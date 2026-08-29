
extends CanvasLayer

@export_file("*.tscn") var target_scene_path: String
@export var exit_msg: String = "Exit this Scene?"
@onready var exit_button: TextureButton = $MarginContainer/TextureButton

func _on_texture_button_pressed() -> void:
	# Not allowing to leave farm if he is carrying something on the mouse cursor
	if not PlayerHeldItem.is_empty():
		return
	
	var is_confirmed = await ConfirmationDialogue.ask_confirmation(exit_msg)
	if not is_confirmed:
		return
	if target_scene_path != "":
		InventoryManager.close_all_uis()
		TravelTransition.change_scene(target_scene_path)
	else:
		push_error("no target path scene")
