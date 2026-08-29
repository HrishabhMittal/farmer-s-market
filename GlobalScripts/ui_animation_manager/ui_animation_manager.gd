extends Node2D

# Makes the passed control node expand a bit
func scale_expand_highlight(target_control_node: Control) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	target_control_node.offset_transform_enabled = true
	await get_tree().process_frame
	tween.tween_property(target_control_node, "offset_transform_scale", Vector2(1.2, 1.2), 0.15)

# Reset the scale of the passed control to 1.0
func scale_expand_unhighlight(target_control_node: Control) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(target_control_node, "offset_transform_scale", Vector2(1.0, 1.0), 0.15)
	#target_control_node.offset_transform_enabled = true
