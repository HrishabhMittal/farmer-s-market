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

enum SlideDirection {LEFT, RIGHT, TOP, BOTTOM}
func slide_in(
	visibility_monitor_node: Node, # Which nodes visibility to monitor to trigger this (This is needed because base node of a InventoryUI is a canvaslayer)
	target_control_node: Control,  # Which node will actually be moved for the animation
	direction: SlideDirection = SlideDirection.LEFT, # Left means it will go from right to left direction and so on
	duration: float = 0.30, 
	distance_offset: float = 300.0
) -> void:
	if not target_control_node:
		return
		
	if not visibility_monitor_node.visible:
		return
	
	target_control_node.offset_transform_enabled = true
	
	var start_pos := Vector2.ZERO
	var target_pos := Vector2.ZERO
	
	match direction:
		SlideDirection.LEFT:
			start_pos.x += distance_offset
		SlideDirection.RIGHT:
			start_pos.x -= distance_offset
		SlideDirection.TOP:
			start_pos.y += distance_offset
		SlideDirection.BOTTOM:
			start_pos.y -= distance_offset
	
	target_control_node.offset_transform_position = start_pos
	target_control_node.modulate.a = 0.5

	var tween := create_tween().set_parallel(true)
	
	tween.tween_property(target_control_node, "offset_transform_position", target_pos, duration)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
		
	tween.tween_property(target_control_node, "modulate:a", 1.0, duration * 0.60)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
