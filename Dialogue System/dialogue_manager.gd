extends CanvasLayer

@onready var label: Label = $Panel/Label
@onready var name_label: Label = $Panel/NameLabel
@export var char_speed: float = 0.03

signal dialogue_finished

var current_lines: Array[String] = []
var current_index: int = 0
var tween: Tween
var is_typing: bool = false


func show_dialog(lines: Array, speaker: String = "NPC") -> void:
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner:
		focus_owner.release_focus()
	current_lines.clear()
	for line in lines:
		current_lines.append(str(line))
	current_index = 0
	name_label.text = speaker
	show()
	_display_current_line()


func show_dialogue(data: DialogueResource) -> void:
	show_dialog(data.lines, data.speaker_name)

func _display_current_line() -> void:
	if current_index >= current_lines.size():
		hide()
		dialogue_finished.emit()
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
	if not visible:
		return
	var is_enter = event is InputEventKey and event.keycode == KEY_ENTER and event.pressed and not event.echo
	if event.is_action_pressed("interact") or event.is_action_pressed("left click") or is_enter:
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
	$Panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Panel/Label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Panel/NameLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
