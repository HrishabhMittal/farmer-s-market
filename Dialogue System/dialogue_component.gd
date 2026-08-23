extends Node
class_name DialogueComponent

signal dialogue_started
signal dialogue_ended #for now these signals dont do nothing

@export var dialogue_data: DialogueResource

func start_dialogue() -> void:
	if dialogue_data:
		emit_signal("dialogue_started")
