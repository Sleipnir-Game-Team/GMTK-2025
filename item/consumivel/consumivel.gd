class_name Consumivel extends Item

func try_use():
	use()
	var new_node = Item.new()
	new_node.name = name
	replace_by(new_node)

func use():
	print("uhhh, you should override this")
