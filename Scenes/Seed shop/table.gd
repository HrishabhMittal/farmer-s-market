extends Area2D

@onready var seed_bag = $"."
 



func _on_area_entered(area: Area2D) -> void:
	if area.name == "seed_pack":
		area.get_parent().scale.x = 3
		area.get_parent().scale.y = 3
		area.on_table = true

func _on_area_exited(area: Area2D) -> void:
	if area.name == "seed_pack":
		area.get_parent().scale.x = 1
		area.get_parent().scale.y = 1
		area.on_table = false
