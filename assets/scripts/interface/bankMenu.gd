extends Panel

class_name BankMenu

const MAX_MONEY: int = 1000

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var pause_menu: PauseMenu = get_tree().get_first_node_in_group("pause_menu")
@onready var name_label: Label = get_node("name")
@onready var take_count: SpinBox = get_node("takeCount")
@onready var debt_label: Label = get_node("debt")
@onready var take_button: Button = get_node("take")
@onready var return_button: Button = get_node("return")

@onready var selling_sound: AudioStream = load("res://assets/audio/buying/selling.mp3")

var bank_stand: StandBase


func _ready() -> void:
	interaction_controller.open_bank_menu.connect(_on_open_menu)


func _process(_delta: float) -> void:
	if !visible: return
	if Input.is_action_just_pressed("ui_cancel"):
		_on_close_pressed()


func _on_close_pressed() -> void:
	visible = false
	movement_controller.may_move = true
	await get_tree().process_frame
	pause_menu.may_pause = true


func _on_open_menu(stand: StandBase) -> void:
	visible = true
	bank_stand = stand
	pause_menu.may_pause = false
	movement_controller.may_move = false
	name_label.text = Loc.trans("items.bank.name")
	debt_label.text = Loc.trans("interface.money.debt") \
		+ " " + str(M.debt) + " " \
		+ Loc.get_plural(M.debt, "bits")
	return_button.disabled = M.debt <= 0 and M.money >= M.debt
	take_button.disabled = !_may_take_debt()


func _may_take_debt() -> bool:
	return M.debt <= 0 and G.time.day < 4


func _on_take_pressed() -> void:
	var count = int(take_count.value)
	if count <= 0: return
	M.add_money(count)
	M.add_debt(count)
	
	bank_stand.audi.stream = selling_sound
	bank_stand.audi.play()
	
	_on_close_pressed()


func _on_return_pressed() -> void:
	if M.money < M.debt: return
	M.remove_money(M.debt)
	M.remove_debt()
	
	bank_stand.audi.stream = selling_sound
	bank_stand.audi.play()
	
	_on_close_pressed()
