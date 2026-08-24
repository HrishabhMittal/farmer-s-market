extends CanvasLayer
class_name DialogueManager
##looks for lines to show and close when lines are finished

@onready var label: Label = $Panel/Label
@onready var name_label: Label = $Panel/NameLabel

var current_lines: Array[String] = []
var current_index: int = 0

func show_dialogue(data: DialogueResource) -> void:
	current_lines = data.lines
	current_index = 0
	name_label.text = data.speaker_name
	show()
	_display_current_line()

func _display_current_line() -> void:
	if current_index < current_lines.size():
		label.text = current_lines[current_index]
	else:
		hide()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		current_index += 1
		_display_current_line()

func _ready() -> void:
	hide()
