extends Area2D
class_name DialogueTriggerArea
##to enter the dialogue

@export var dialogue_component: DialogueComponent
var player_in_range: bool = false

func _ready() -> void:
	body_entered.connect(func(body): if body.is_in_group("Player"): player_in_range = true)
	body_exited.connect(func(body): if body.is_in_group("Player"): player_in_range = false)

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		if dialogue_component:
			dialogue_component.start_dialogue()
