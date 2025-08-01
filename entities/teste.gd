extends Node

var rng = RandomNumberGenerator.new()
@onready var inventory = GameManager.find_node("Inventory", get_parent())

var chosen = []
var type = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_8:
				print("Inventario")
				for item in inventory.get_children():
					print(item.get_script().resource_path.get_file())
			KEY_9:
				print("Escolhidos")
				for item in chosen:
					print(item.resource_path.get_file())
			KEY_U:
				var lista = ItemsList.ativo
				chosen = []
				for i in range(3):
					var chosen_pos = rng.randi_range(0, lista.size()-1)
					chosen.append(lista.pop_at(chosen_pos))
				type = Ativo
			KEY_I:
				var lista = ItemsList.consumivel
				chosen = []
				for i in range(3):
					var chosen_pos = rng.randi_range(0, lista.size()-1)
					chosen.append(lista.pop_at(chosen_pos))
				type = Consumivel
			KEY_O:
				var lista = ItemsList.permanente
				chosen = []
				for i in range(3):
					var chosen_pos = rng.randi_range(0, lista.size()-1)
					chosen.append(lista.pop_at(chosen_pos))
				type = Permanente
			KEY_J:
				var item = Item.new()
				item.set_script(chosen[0])
				if type == Permanente:
					inventory.add_child(item)
				else:
					inventory.replace(1, item)
			KEY_K:
				var item = Item.new()
				item.set_script(chosen[1])
				if type == Permanente:
					inventory.add_child(item)
				else:
					inventory.replace(2, item)
			KEY_L:
				var item = Item.new()
				item.set_script(chosen[2])
				if type == Permanente:
					inventory.add_child(item)
				else:
					inventory.replace(3, item)
		
