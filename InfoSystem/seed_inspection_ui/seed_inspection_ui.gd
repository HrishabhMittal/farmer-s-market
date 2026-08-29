extends PanelContainer
class_name SeedInspectionUI # Actually can be used to inspect anythings

func _ready():
	pivot_offset = size / 2.0
	offset_transform_enabled = true	
	
func inspect_item(seed: Item) -> SeedInspectionUI:
	$TextureRect.texture = seed.item_data.item_texture
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "offset_transform_scale", Vector2(2.0, 2.0), 0.15)
	
	return self

func end_inspection() -> void:
	call_deferred("queue_free")
