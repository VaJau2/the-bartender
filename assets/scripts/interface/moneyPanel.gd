extends Panel

const UPDATE_COOLDOW_TIME: float = 0.01

@onready var money: Label = get_node("money")

@onready var goalLabel: Label = get_node("goalLabel")
@onready var goal: Label = get_node("goal")

var temp_money: int = 0

var update_cooldown: float


func _ready() -> void:
	M._ready()
	temp_money = M.money
	_update_money_text()
	M.money_updated.connect(_on_money_updated)
	M.money_force_updated.connect(_on_money_force_updated)
	G.game_manager.start_freeplay.connect(_on_freeplay)


func _process(delta: float) -> void:
	if temp_money != M.money:
		if update_cooldown > 0:
			update_cooldown -= delta
		else:
			temp_money = int(move_toward(temp_money, M.money, 1))
			_update_money_text()
			update_cooldown = UPDATE_COOLDOW_TIME
	else:
		set_process(false)


func _update_money_text() -> void:
	money.text = str(temp_money)


func _on_money_updated() -> void:
	set_process(true)


func _on_money_force_updated() -> void:
	temp_money = M.money
	_update_money_text()


func _on_freeplay() -> void:
	goalLabel.visible = false
	goal.visible = false
