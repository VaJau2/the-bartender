extends ProgressBar

@export var colors: Array[WeightBarColor]


func _on_value_changed(new_value: float) -> void:
	var percent = new_value / max_value * 100
	for color_data in colors:
		if percent > color_data.min_percent and percent < color_data.max_percent:
			modulate = color_data.color
			return
