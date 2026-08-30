extends Node2D


@onready var phone = $CanvasLayer/Phone
@onready var phone_icon = $CanvasLayer/PhoneIcon


var is_phone_open = false
var phone_original_pos: Vector2
var phone_icon_pos: Vector2


func _ready() -> void:
	AudioManager.play_music("Farm Day Alternate")
	
	if phone and phone_icon:
		phone_original_pos = phone.position
		phone_icon_pos = phone_icon.position
		phone.position.y = 1200
		
		phone_icon.pressed.connect(_on_phone_icon_clicked)
		phone.close_requested.connect(close_phone)
	
	if not StateManager.visited_scenes.get("minimap", false):
		StateManager.visited_scenes["minimap"] = true
		DialogueManager.show_dialog(GameDialogues.MOM_MINIMAP, "Mom")
	elif randf() <= GameConfig.mom_ask_money_chance:
		ask_mom_money()
		
	phone_icon.mouse_entered.connect(UIAnimationManager.scale_expand_highlight.bind(phone_icon))
	phone_icon.mouse_exited.connect(UIAnimationManager.scale_expand_unhighlight.bind(phone_icon))


func _on_phone_icon_clicked():
	if is_phone_open:
		return
	is_phone_open = true
	var tween = create_tween().set_parallel(true)

	tween.tween_property(phone_icon, "position:x", phone_icon_pos.x - 100.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(phone_icon, "modulate:a", 0.0, 0.4)

	tween.tween_property(phone, "position:y", phone_original_pos.y, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close_phone():
	if not is_phone_open:
		return
	is_phone_open = false
	var tween = create_tween().set_parallel(true)
	tween.tween_property(phone, "position:y", 1200.0, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(phone_icon, "position:x", phone_icon_pos.x, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(phone_icon, "modulate:a", 1.0, 0.4)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") or event.is_action_pressed("right click"):
		if is_phone_open:
			close_phone()
			get_viewport().set_input_as_handled()
			
	# Consume all unhandled input
	# get_viewport().set_input_as_handled() # It's disabling dialogue input

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
