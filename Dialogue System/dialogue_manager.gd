extends CanvasLayer
class_name DialogueManager
##looks for lines to show and close when lines are finished

@onready var label: Label = $Panel/Label
@onready var name_label: Label = $Panel/NameLabel

@export var char_speed: float = 0.03

var current_lines: Array[String] = []
var current_index: int = 0
var tween: Tween
var is_typing: bool = false

func show_dialogue(data: DialogueResource) -> void:
	current_lines = data.lines
	current_index = 0
	name_label.text = data.speaker_name
	show()
	_display_current_line()

func _display_current_line() -> void:
	#if current_index < current_lines.size():
		#label.text = current_lines[current_index]
	#else:
		#hide()

	if current_index >= current_lines.size():
		hide()
		return

	var full_text: String = current_lines[current_index]
	label.text = full_text
	label.visible_ratio = 0.0
	is_typing = true

	if tween and tween.is_running():
		tween.kill()

	var duration: float = full_text.length() * char_speed
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, duration)
	tween.finished.connect(func(): is_typing = false)


func _unhandled_input(event: InputEvent) -> void:
	#if visible and event.is_action_pressed("ui_accept"):
		#current_index += 1
		#_display_current_line()

	if not visible: return

	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		if is_typing:
			tween.kill()
			label.visible_ratio = 1.0
			is_typing = false
		else:
			current_index += 1
			_display_current_line()

func _ready() -> void:
	hide()
