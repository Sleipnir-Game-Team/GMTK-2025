extends Node

var origin_root: Node = null
var origin_state: Dictionary[String, PackedByteArray] = {}

var rewind_count: int = 0

var buff_capsule: Array[String] = []

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_CTRL:
				load_state()

func rewind() -> void:
	GameManager.pause()

func save_state(root: Node) -> void:
	origin_root = root
	pack(root, origin_state)

func load_state() -> void:
	if origin_root == null:
		return
	rewind_count += 1
	
	var group_capsule: Dictionary[String, Array] = {}
	var time_capsule: Dictionary[String, PackedByteArray]= {}
	var rewind_proof_nodes := get_tree().get_nodes_in_group("rewind_proof")
	for node in rewind_proof_nodes:
		pack(node, time_capsule)
		group_capsule[node.get_path().get_concatenated_names()] = node.get_groups()
	
	var parent: Node = origin_root.get_parent()
	for child in origin_root.get_children():
		origin_root.remove_child(child)
		child.queue_free()
	
	var new_present := unpack(origin_state, time_capsule, group_capsule)
	
	for child in new_present.get_children():
		child.reparent(origin_root)
	new_present.queue_free()

func pack(start: Node, main: Dictionary[String, PackedByteArray]) -> void:
	main[start.get_path().get_concatenated_names()] = var_to_bytes_with_objects(start)
	for child in start.get_children():
		if child.is_in_group("rewind_prone"):
			prints("Yes Rico, Kaboom", child.name)
			continue
		pack(child, main)

func unpack(main: Dictionary[String, PackedByteArray], 
			time_capsule: Dictionary[String, PackedByteArray],
			group_capsule: Dictionary[String, Array]
			) -> Node:
	var nodes_pile: Array[Node] = []
	var path_pile: Array[NodePath] = []
	
	var keys:= main.keys()
	keys.reverse()
	
	for key: String in keys:
		var path: = NodePath(key)
		var node_to_use: = time_capsule if time_capsule.has(key) else main
		var node: Node = bytes_to_var_with_objects(node_to_use[key])
		node.name = path.get_name(path.get_name_count()-1)
		
		if group_capsule.has(key):
			for group: StringName in group_capsule.get(key):
				if not str(group).begins_with("_"):
					node.add_to_group(group)
		
		while nodes_pile.size() > 0 and path == path_pile.back().slice(0, -1):
			node.add_child(nodes_pile.pop_back())
			path_pile.pop_back()
		
		nodes_pile.push_back(node)
		path_pile.push_back(path)
	
	return nodes_pile.pop_back()


func load_buff() -> Array[String]:
	var dup := buff_capsule.duplicate()
	buff_capsule = []
	return dup

func save_buff(buff_script: String) -> void:
	buff_capsule.append(buff_script)
