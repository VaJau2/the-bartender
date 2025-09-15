extends Label

class_name StatisticsCountLabel

@export var code: String
@export var method: Method
@export var unit: Unit


func calculate() -> void:
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
			if value.size() > 0:
				value = snapped(G.statistics.get_average(value), 0.01)
				result_text = str(value)
			else:
				result_text = str(0.0)
		Method.GetMax:
			var value = G.statistics.get(code)
			result_text = str(G.statistics.get_max(value))
		Method.GetMostSoldDrink:
			var value = G.statistics.get_most_sold_drink()
			if value != "":
				result_text = Loc.trans("items." + value + ".name")
			else:
				result_text = "None"
		Method.GetMostProfitDrink:
			var value = G.statistics.get_most_profit_drink()
			if value != "":
				result_text = Loc.trans("items." + value + ".name")
			else:
				result_text = "None"
	
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
