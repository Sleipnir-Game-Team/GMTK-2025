extends Node

func _ready():
	var current_buff_capsule := TimeWizard.load_buff()
	for buff in current_buff_capsule:
		var buff_script := load(buff)
		var item := Permanente.new()
		item.add_to_group("rewind_prone")
		item.script = buff_script
		add_child(item)
		
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

func switch(slotNumber1, slotNumber2):
	var node1 =  get_node(str(slotNumber1))
	var node2 =  get_node(str(slotNumber2))
	node1.name = 0
	node2.name = slotNumber1
	node1.name = slotNumber2

func replace(slotNumber, item):
	var target = get_node(str(slotNumber))
	item.name = str(slotNumber)
	target.replace_by(item)
	

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
