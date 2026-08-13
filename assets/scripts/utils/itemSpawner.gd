class_name ItemSpawner

static var base_item_path: String = "res://objects/props/items/base-item.tscn"
static var temp_item_id: int = 0


static func spawn_item(code: String, position: Vector2, parent: Node) -> Item:
	var item: Item = load(base_item_path).instantiate()
	item.add_to_group("spawned_item")
	item.save_id = temp_item_id
	temp_item_id += 1
	item.code = code
	parent.add_child(item)
	item.global_scale = Vector2.ONE
	item.global_position = position
	return item
