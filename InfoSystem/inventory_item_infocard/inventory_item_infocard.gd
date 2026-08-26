extends CanvasLayer
class_name InventoryItemInfocard

@export var name_label: Label
@export var texture_node: TextureRect
@export var price_label: Label
@export var descript_label: Label

func show_infocard(item: Item) -> void:
	name_label.text = item.item_data.display_name
	texture_node.texture = item.item_data.item_texture
	price_label.text = str(item.item_data.value)
	descript_label.text = item.item_data.item_description
	visible = true
	reposition()

func hide_infocard() -> void:
	visible = false

# Need to reposition it based on the current mouse position
func reposition() -> void:
	var mouse_pos = get_viewport().get_mouse_position()

	var viewport_rect = $PanelContainer.get_viewport_rect()
	var card_size = $PanelContainer.size

	var target_pos = mouse_pos# + offset
	if target_pos.x + card_size.x > viewport_rect.size.x:
		target_pos.x = mouse_pos.x - card_size.x# - offset.x
		
	if target_pos.y + card_size.y > viewport_rect.size.y:
		target_pos.y = mouse_pos.y - card_size.y# - offset.y

	target_pos.x = max(0.0, target_pos.x)
	target_pos.y = max(0.0, target_pos.y)

	$PanelContainer.global_position = target_pos
