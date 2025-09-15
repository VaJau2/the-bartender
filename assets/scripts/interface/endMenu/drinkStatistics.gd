extends Control

@onready var icon: TextureRect = get_node("icon")
@onready var nameLabel: Label = get_node("name")
@onready var soldCountLable: Label = get_node("soldCount")
@onready var profitLable: Label = get_node("profit")

func init(code: String) -> void:
	icon.texture = load("res://assets/sprites/items/" + code + ".png")
	nameLabel.text = Loc.trans("items." + code + ".name")
	soldCountLable.text = "x" + str(G.statistics.drinks_stats[code].amount)
	profitLable.text = str(G.statistics.drinks_stats[code].profit) + " B"
