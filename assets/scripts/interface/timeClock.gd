extends Panel

@onready var label: Label = get_node("label")


func _ready() -> void:
	label.text = G.time.get_time_formatted()
	G.time.minute_tick.connect(_on_minute_tick)


func _on_minute_tick() -> void:
	label.text = G.time.get_time_formatted()
