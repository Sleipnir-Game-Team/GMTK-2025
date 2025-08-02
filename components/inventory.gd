extends Node

func _ready() -> void:
	var current_buff_capsule := TimeWizard.load_buff()
	for buff in current_buff_capsule:
		var buff_script := load(buff)
		var item := Permanente.new()
		item.add_to_group("rewind_prone")
		item.script = buff_script
		add_child(item)
		
	if !has_node("1"):
		var node_1 := Item.new()
		node_1.name = "1"
		add_child(node_1)
		
	if !has_node("2"):
		var node_2 := Item.new()
		node_2.name = "2"
		add_child(node_2)
	
	if !has_node("3"):
		var node_3 := Item.new()
		node_3.name = "3"
		add_child(node_3)
	
	if !has_node("4"):
		var node_4 := Item.new()
		node_4.name = "4"
		add_child(node_4)

func switch(slotNumber1: int, slotNumber2: int) -> void:
	var first := str(slotNumber1)
	var second : = str(slotNumber2)
	var node1: Node = get_node(first)
	var node2: Node = get_node(second)
	node1.name = "0"
	node2.name = first
	node1.name = second

func replace(slotNumber: int, item: Item) -> void:
	var new_name := str(slotNumber)
	var target: Node = get_node(new_name)
	item.name = new_name
	target.replace_by(item)


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event.is_action("item_1"):
		get_node("1").try_use()
	elif event.is_action("item_2"):
		get_node("2").try_use()
	elif event.is_action("item_3"):
		get_node("3").try_use()
	elif event.is_action("item_4"):
		get_node("4").try_use()
