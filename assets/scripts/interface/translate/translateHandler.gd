extends Node

@export var nodes: Array[TranslateData]


func _ready() -> void:
	for node_data in nodes:
		var node = get_node(node_data.node_path)
		if node.get("text"):
			node.text = Loc.trans("interface." + node_data.code)
