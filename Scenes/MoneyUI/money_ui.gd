extends CanvasLayer
class_name MoneyUI

@onready var money_label: Label = $MarginContainer/PanelContainer/HBoxContainer/Label

func _process(_delta: float) -> void:
	if money_label and StateManager:
		money_label.text = str(StateManager.money)
