extends Area2D
class_name DialogueTriggerArea
##to enter the dialogue

@export var dialogue_component: DialogueComponent
@export var dialogue_manager: DialogueManager
var player_in_range: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		start_conversation()

func start_conversation() -> void:
	if dialogue_component:
			dialogue_component.start_dialogue()
			dialogue_manager.show_dialogue(dialogue_component.dialogue_data)
