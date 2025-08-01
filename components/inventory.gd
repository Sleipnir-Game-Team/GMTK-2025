extends Node

func _ready():
	if !has_node("1"):
		var node_1 = Item.new()
		node_1.name = "1"
		add_child(node_1)
	if !has_node("2"):
		var node_2 = Item.new()
		node_2.name = "2"
		add_child(node_2)
	if !has_node("3"):
		var node_3 = Item.new()
		node_3.name = "3"
		add_child(node_3)
	if !has_node("4"):
		var node_4 = Item.new()
		node_4.name = "4"
		add_child(node_4)

func switch(slot1, slot2):
	var aux = slot1
	get_node(str(slot1)).replace_by(slot2)
	get_node(str(slot2)).replace_by(aux)

func replace(slot):
	get_node(str(slot)).replace_by(slot)

func _input(event):
	if event.is_pressed():
		if event.is_action("item_1"):
			get_node("1").try_use()
		elif event.is_action("item_2"):
			get_node("2").try_use()
		elif event.is_action("item_3"):
			get_node("3").try_use()
		elif event.is_action("item_4"):
			get_node("4").try_use()
