extends Node

class_name SignalConnectionsSerializer


static func get_signal_connections_data(obj: Node) -> Dictionary:
	var result: Dictionary = {}
	
	var script := obj.get_script() as Script
	
	while script != null:
		for signal_data: Dictionary in script.get_script_signal_list():
			var signal_name := StringName(signal_data["name"])
			var signal_key := String(signal_name)
			
			# Базовый скрипт может вернуть сигнал, который уже был обработан.
			if result.has(signal_key):
				continue
			
			var temp_signal := Signal(obj, signal_name)
			var serialized_connections: Array[Dictionary] = []
			
			for connection: Dictionary in temp_signal.get_connections():
				var callable: Callable = connection["callable"]
				var target := callable.get_object()
				
				# NodePath можно надежно восстановить только для Node.
				if not target is Node:
					push_warning(
						"SignalConnectionsSerializer: connection '%s' skipped: target is not a Node."
						% signal_name
					)
					continue
				
				var target_node := target as Node
				var method := callable.get_method()
				
				# Анонимные/локальные Callable нельзя надежно восстановить
				# через Callable(target, method).
				if not target_node.has_method(method):
					push_warning(
						"SignalConnectionsSerializer: connection '%s -> %s' skipped: callable cannot be reconstructed."
						% [signal_name, method]
					)
					continue
				
				if not obj.is_inside_tree() or not target_node.is_inside_tree():
					push_warning(
						"SignalConnectionsSerializer: connection '%s' skipped: nodes must be inside SceneTree."
						% signal_name
					)
					continue
				
				serialized_connections.append({
					"target_path": String(obj.get_path_to(target_node)),
					"method": String(method),
					"flags": int(connection["flags"]),
					"bound_arguments": callable.get_bound_arguments(),
					"unbound_arguments_count": callable.get_unbound_arguments_count(),
				})
			
			if not serialized_connections.is_empty():
				result[signal_key] = serialized_connections
			
		script = script.get_base_script()
	
	return result


static func load_signal_connections_data(obj: Node, data: Dictionary) -> void:
	for signal_key: Variant in data:
		var signal_name := StringName(signal_key)
		
		if not obj.has_signal(signal_name):
			push_warning(
				"SignalConnectionsSerializer: signal '%s' does not exist on node '%s'."
				% [signal_name, obj.name]
			)
			continue
		
		var temp_signal := Signal(obj, signal_name)
		var connections: Array = data[signal_key]
		
		for connection_data: Dictionary in connections:
			var target_path := NodePath(
				String(connection_data.get("target_path", ""))
			)
			
			var target := obj.get_node_or_null(target_path)
			
			if target == null:
				push_warning(
					"SignalConnectionsSerializer: target '%s' for signal '%s' was not found."
					% [target_path, signal_name]
				)
				continue
			
			var method := StringName(
				connection_data.get("method", "")
			)
			
			if not target.has_method(method):
				push_warning(
					"SignalConnectionsSerializer: method '%s' does not exist on '%s'."
					% [method, target.name]
				)
				continue
			
			var callable := Callable(target, method)
			
			var bound_arguments: Array = connection_data.get(
				"bound_arguments",
				[]
			)
			
			if not bound_arguments.is_empty():
				callable = callable.bindv(bound_arguments)
			
			var unbound_arguments_count := int(
				connection_data.get("unbound_arguments_count", 0)
			)
			
			if unbound_arguments_count > 0:
				callable = callable.unbind(unbound_arguments_count)
			
			# Например, соединение могло уже восстановиться через _ready()
			# или быть прописано в сцене.
			if temp_signal.is_connected(callable):
				continue
			
			var flags := int(
				connection_data.get("flags", 0)
			)
			
			var error := temp_signal.connect(callable, flags)
			
			if error != OK:
				push_warning(
					"SignalConnectionsSerializer: failed to connect '%s' to '%s.%s'. Error: %s"
					% [
						signal_name,
						target.name,
						method,
						error,
					]
				)
