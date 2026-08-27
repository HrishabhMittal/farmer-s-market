extends CanvasLayer

signal confirmation_answered(result: bool)

@onready var color_rect = $ColorRect
@onready var panel = $PanelContainer
@onready var message_label = %MessageLabel

func _ready() -> void:
	hide()
	
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/YesButton.pressed.connect(_on_yes)
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NoButton.pressed.connect(_on_no)

func ask_confirmation(msg: String) -> bool:
	message_label.text = msg
	show()
	
	var viewport_size = get_viewport().get_visible_rect().size
	var target_y = (viewport_size.y - panel.size.y) / 2.0
	
	color_rect.modulate.a = 0.0
	panel.position.x = (viewport_size.x - panel.size.x) / 2.0
	panel.position.y = -panel.size.y
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.3)
	tween.tween_property(panel, "position:y", target_y, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	var result = await self.confirmation_answered
	
	var out_tween = create_tween().set_parallel(true)
	out_tween.tween_property(color_rect, "modulate:a", 0.0, 0.3)
	out_tween.tween_property(panel, "position:y", viewport_size.y + 50.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	await out_tween.finished
	hide()
	
	return result

func _on_yes() -> void:
	confirmation_answered.emit(true)

func _on_no() -> void:
	confirmation_answered.emit(false)
