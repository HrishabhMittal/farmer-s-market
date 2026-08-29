extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("Farm Day Alternate")
	if not StateManager.visited_scenes.get("minimap", false):
		StateManager.visited_scenes["minimap"] = true
		DialogueManager.show_dialog([GameDialogues.MOM_MINIMAP], "Mom")
	elif randf() <= GameConfig.mom_ask_money_chance:
		ask_mom_money()

func ask_mom_money():
	DialogueManager.show_dialog([GameDialogues.MOM_ASK_MONEY], "Mom")
	await DialogueManager.dialogue_finished
	var confirm = await ConfirmationDialogue.ask_confirmation("Send 500 Coins?")
	if confirm:
		if StateManager.money >= 500:
			StateManager.money -= 500
			DialogueManager.show_dialog([GameDialogues.MOM_MONEY_SENT], "Mom")
		else:
			InfocardManager.show_floating_text("Not enough funds!", get_global_mouse_position(), "Red")
			DialogueManager.show_dialog([GameDialogues.MOM_MONEY_DECLINED], "Mom")
	else:
		DialogueManager.show_dialog([GameDialogues.MOM_MONEY_DECLINED], "Mom")
