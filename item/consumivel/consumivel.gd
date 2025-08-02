class_name Consumivel extends Item

func try_use() -> void:
	use()
	var new_node := Item.new()
	new_node.name = name
	replace_by(new_node)

func use() -> void:
	print("uhhh, you should override this")
