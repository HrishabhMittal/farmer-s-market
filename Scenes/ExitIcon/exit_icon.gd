
extends CanvasLayer

@export_file("*.tscn") var target_scene_path: String
@export var exit_msg: String = "Exit this Scene?"
@onready var exit_button: TextureButton = $MarginContainer/TextureButton

func _ready():
	exit_button.mouse_entered.connect(highlight)
	exit_button.mouse_exited.connect(unhighlight) 

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

func highlight() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(exit_button, "offset_transform_scale", Vector2(1.2, 1.2), 0.15)

func unhighlight() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(exit_button, "offset_transform_scale", Vector2(1.0, 1.0), 0.15)
