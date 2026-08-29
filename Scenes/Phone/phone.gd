extends Node2D

signal close_requested

@onready var main_screen = $UI_Root/MainScreen
@onready var contacts_screen = $UI_Root/ContactsScreen
@onready var browser_screen = $UI_Root/BrowserScreen
@onready var bank_screen = $UI_Root/BankScreen
@onready var dialog_screen = $UI_Root/DialogScreen
@onready var dialog_text = $UI_Root/DialogScreen/DialogText
@onready var amount_input = $UI_Root/BankScreen/AmountInput
@onready var bank_balance_label = $UI_Root/BankScreen/BankBalance

var current_shop_id: String = ""

func _ready() -> void:
	
	var current_scene = get_tree().current_scene
	if current_scene and "shop_id" in current_scene:
		current_shop_id = current_scene.shop_id
	
	$UI_Root/MainScreen/AppPhone.pressed.connect(_on_app_phone_pressed)
	$UI_Root/MainScreen/AppBank.pressed.connect(_on_app_bank_pressed)
	$UI_Root/MainScreen/AppBrowser.pressed.connect(_on_app_browser_pressed)
	$UI_Root/MainScreen/AppPower.pressed.connect(_on_app_power_pressed)
	
	$UI_Root/ContactsScreen/BtnMom.pressed.connect(_on_btn_mom_pressed)
	$UI_Root/ContactsScreen/BtnPolice.pressed.connect(_on_btn_police_pressed)
	$UI_Root/ContactsScreen/BtnBack.pressed.connect(show_main_screen)
	
	$UI_Root/BrowserScreen/BtnBack.pressed.connect(show_main_screen)
	$UI_Root/BankScreen/BtnBack.pressed.connect(show_main_screen)
	$UI_Root/BankScreen/BtnDeposit.pressed.connect(_on_btn_deposit_pressed)
	
	$UI_Root/DialogScreen/BtnEndCall.pressed.connect(show_main_screen)
	
	show_main_screen()

func show_screen(screen_node: Control) -> void:
	main_screen.hide()
	contacts_screen.hide()
	browser_screen.hide()
	bank_screen.hide()
	dialog_screen.hide()
	screen_node.show()

func show_main_screen() -> void:
	print("main screen")
	show_screen(main_screen)


func _on_app_phone_pressed() -> void:
	print("phone app")
	show_screen(contacts_screen)

func _on_app_bank_pressed() -> void:
	print("bankapp")
	amount_input.text = ""
	if bank_balance_label:
		bank_balance_label.text = "Balance: %d Coins" % StateManager.bank_balance
	show_screen(bank_screen)

func _on_app_browser_pressed() -> void:
	print("browser")
	show_screen(browser_screen)

func _on_app_power_pressed() -> void:
	print("power")
	AudioManager.play_sfx("Click SFX")
	close_requested.emit()

func _on_btn_mom_pressed() -> void:
	show_screen(dialog_screen)
	dialog_text.text = GameDialogues.CALL_MOM_BUSY
	dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _on_btn_police_pressed() -> void:
	AudioManager.play_sfx("Farm Police")
	show_screen(dialog_screen)
	dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	if current_shop_id == "":
		dialog_text.text = GameDialogues.CALL_POLICE_NO_TARGET
	elif not StateManager.police_called_shops.has(current_shop_id):
		StateManager.police_called_shops.append(current_shop_id)
		dialog_text.text = GameDialogues.CALL_POLICE
	else:
		dialog_text.text = "We already have an active investigation for this location."

func _on_btn_deposit_pressed() -> void:
	var amount = amount_input.text.to_int()
	if amount > 0 and StateManager.money >= amount:
		StateManager.money -= amount
		StateManager.bank_balance += amount
		amount_input.text = ""
		if bank_balance_label: bank_balance_label.text = "Balance: %d Coins" % StateManager.bank_balance
		AudioManager.play_sfx("Buy")
		show_screen(dialog_screen)
		dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		if StateManager.bank_balance >= GameConfig.target_money:
			dialog_text.text = GameDialogues.BANK_ENDING
		else:
			dialog_text.text = GameDialogues.BANK_DEPOSIT
	else:
		if InfocardManager: InfocardManager.show_floating_text("Invalid funds!", get_global_mouse_position(), "Red")
