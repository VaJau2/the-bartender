extends Label

@export var code: String
@export var method: Method
@export var unit: Unit


func _ready() -> void:
	var result_text: String
	
	match method:
		Method.None:
			var value = G.statistics.get(code)
			result_text = str(value)
		Method.GetTotal:
			var value = G.statistics.get(code)
			result_text = str(G.statistics.get_total(value))
		Method.GetAverage:
			var value = G.statistics.get(code)
			value = snapped(G.statistics.get_average(value), 0.01)
			result_text = str(value)
		Method.GetMax:
			var value = G.statistics.get(code)
			result_text = str(G.statistics.get_max(value))
		Method.GetMostSoldDrink:
			var value = G.statistics.get_most_sold_drink()
			result_text = Loc.trans("items." + value + ".name")
		Method.GetMostProfitDrink:
			var value = G.statistics.get_most_profit_drink()
			result_text = Loc.trans("items." + value + ".name")
	
	match unit:
		Unit.x:
			text = "x" + result_text
		Unit.B:
			text = result_text + " B"
		Unit.xB:
			var itemStats = G.statistics.get(code)
			text = "x" + str(itemStats.amount) + " (" + str(itemStats.profit) + " B)"
		Unit.sec:
			text = result_text + " " + Loc.trans("interface.resume.seconds")
		Unit.None:
			text = result_text


enum Method {
	None,
	GetTotal,
	GetAverage,
	GetMax,
	GetMostSoldDrink,
	GetMostProfitDrink
}

enum Unit {
	x,
	B,
	xB,
	sec,
	None
}
