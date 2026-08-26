extends CanvasLayer
class_name FarmplantInfocard

@export var plant_name: Label
@export var plant_texture: TextureRect

@export var stage_label: RichTextLabel
@export var harvest_label: Label
@export var water_label: RichTextLabel
@export var rain_label: Label

func show_infocard(new_plant: FarmPlant) -> void:
	plant_name.text = new_plant.display_name
	plant_texture.texture = new_plant.growth_cycle_texture[new_plant.current_growth_cycle]
	
	stage_label.text = str(new_plant.current_growth_cycle+1) if new_plant.current_growth_cycle < new_plant.growth_cycle_day.size() else "[color=green]Ready[/color]"
	harvest_label.text = str(new_plant.production_amount)
	water_label.text = "[color=green]Yes[/color]" if new_plant.is_watered() else "[color=red]No[/color]"
	#rain_label.text = ""
	
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
