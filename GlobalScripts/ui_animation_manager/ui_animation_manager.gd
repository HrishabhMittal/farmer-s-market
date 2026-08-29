extends Node2D

# Makes the passed control node expand a bit
func scale_expand_highlight(target_control_node: Control, adjust_pivot_offseft: bool = true) -> void:
	if adjust_pivot_offseft:
		target_control_node.pivot_offset = target_control_node.size / 2.0
	target_control_node.offset_transform_enabled = true	
		
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(target_control_node, "offset_transform_scale", Vector2(1.2, 1.2), 0.15)

# Reset the scale of the passed control to 1.0
func scale_expand_unhighlight(target_control_node: Control) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(target_control_node, "offset_transform_scale", Vector2(1.0, 1.0), 0.15)
	#target_control_node.offset_transform_enabled = true

# Expands and shakes
func scale_expand_shake_highlight(target_control_node: Control, adjust_pivot_offseft: bool = true) -> void:
	if adjust_pivot_offseft:
		target_control_node.pivot_offset = target_control_node.size / 2.0
	target_control_node.offset_transform_enabled = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(target_control_node, "offset_transform_scale", Vector2(1.2, 1.2), 0.15)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	var shake_tween = create_tween()
	shake_tween.tween_property(target_control_node, "rotation_degrees", 6.0, 0.1)
	shake_tween.tween_property(target_control_node, "rotation_degrees", -6.0, 0.1)
	shake_tween.tween_property(target_control_node, "rotation_degrees", 3.0, 0.1)
	shake_tween.tween_property(target_control_node, "rotation_degrees", 0.0, 0.1)

func scale_expand_shake_unhighlight(target_control_node: Control) -> void:
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(target_control_node, "offset_transform_scale", Vector2(1.0, 1.0), 0.15)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
		
	tween.tween_property(target_control_node, "rotation_degrees", 0.0, 0.15)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
