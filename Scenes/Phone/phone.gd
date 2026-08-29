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
var is_calling: bool = false
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
	_remove_boxes_recursive(self)

# i aint gonna sit there and remove from each component manually
func _remove_boxes_recursive(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			child.flat = true
		elif child is LineEdit:
			child.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
			child.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		
		if child.get_child_count() > 0:
			_remove_boxes_recursive(child)


func show_screen(screen_node: Control) -> void:
	main_screen.hide()
	contacts_screen.hide()
	browser_screen.hide()
	bank_screen.hide()
	dialog_screen.hide()
	screen_node.show()

func show_main_screen() -> void:
	show_screen(main_screen)


func _on_app_phone_pressed() -> void:
	show_screen(contacts_screen)

func _on_app_bank_pressed() -> void:
	amount_input.text = ""
	if bank_balance_label:
		bank_balance_label.text = "Balance: %d Coins" % StateManager.bank_balance
	show_screen(bank_screen)

func _on_app_browser_pressed() -> void:
	show_screen(browser_screen)

func _on_app_power_pressed() -> void:
	AudioManager.play_sfx("Click SFX")
	close_requested.emit()
func _on_btn_police_pressed() -> void:
	if is_calling: 
		return
	is_calling = true
	
	var sfx = AudioManager.play_ringtone("Farm Police", 2)
	if sfx:
		await sfx.finished
		
	var dialog_line = ""
	
	if current_shop_id == "":
		dialog_line = GameDialogues.CALL_POLICE_NO_TARGET
	elif not StateManager.police_called_shops.has(current_shop_id):
		StateManager.police_called_shops.append(current_shop_id)
		dialog_line = GameDialogues.CALL_POLICE
	else:
		dialog_line = "We already have an active investigation for this location."
		
	close_requested.emit()
	DialogueManager.show_dialog([dialog_line], "Police Dispatch")
	
	is_calling = false

func _on_btn_mom_pressed() -> void:
	if is_calling: 
		return
	is_calling = true

	var sfx = AudioManager.play_ringtone("Farm Phone Mom", 1.5)
	if sfx:
		await sfx.finished

	close_requested.emit()
	DialogueManager.show_dialog([GameDialogues.CALL_MOM_BUSY], "Mom")
	
	is_calling = false
	
func _on_btn_deposit_pressed() -> void:
	var amount = amount_input.text.to_int()
	if amount > 0 and StateManager.money >= amount:
		StateManager.money -= amount
		StateManager.bank_balance += amount
		amount_input.text = ""
		if bank_balance_label:
			bank_balance_label.text = "Balance: %d Coins" % StateManager.bank_balance
		AudioManager.play_sfx("Buy")
		
		var dialog_line = ""
		if StateManager.bank_balance >= GameConfig.target_money:
			dialog_line = GameDialogues.BANK_ENDING
		else:
			dialog_line = GameDialogues.BANK_DEPOSIT
			
		close_requested.emit()
		DialogueManager.show_dialog([dialog_line], "Bank Call")
	else:
		if InfocardManager:
			InfocardManager.show_floating_text("Invalid funds!", get_global_mouse_position(), "Red")
