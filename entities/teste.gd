extends Node

var rng := RandomNumberGenerator.new()

var chosen: Array[GDScript] = []
var type = null

func _ready():
	UI_Controller.select_augment.connect(func_teste_selecionar)
	UI_Controller.discard_augment.connect(func_teste_descartar)

func func_teste_selecionar(selecionado):
	print(selecionado)
func func_teste_descartar(descartado):
	print(descartado)

func _input(event: InputEvent) -> void:
	var inventory: Node = GameManager.find_node("Inventory", get_parent())
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_8:
				print("Inventario")
				for item: Item in inventory.get_children():
					print(item.get_script().resource_path.get_file())
			KEY_9:
				print("Escolhidos")
				for item: GDScript in chosen:
					print(item.resource_path.get_file())
				UI_Controller.processAction("augment", chosen)
			KEY_U:
				var lista := ItemsList.ativo.duplicate()
				chosen = []
				for i in range(3):
					var chosen_pos := rng.randi_range(0, lista.size()-1)
					chosen.append(lista.pop_at(chosen_pos).script)
				type = Ativo
			KEY_I:
				var lista := ItemsList.consumivel.duplicate()
				chosen = []
				for i in range(3):
					var chosen_pos := rng.randi_range(0, lista.size()-1)
					chosen.append(lista.pop_at(chosen_pos))
				type = Consumivel
			KEY_O:
				var lista := ItemsList.permanente.duplicate()
				chosen = []
				for i in range(3):
					var chosen_pos := rng.randi_range(0, lista.size()-1)
					chosen.append(lista.pop_at(chosen_pos))
				type = Permanente
			KEY_J:
				var item := Item.new()
				item.set_script(chosen[0])
				if type == Permanente:
					item.add_to_group("rewind_prone")
					inventory.add_child(item)
				else:
					inventory.replace(1, item)
			KEY_K:
				var item := Item.new()
				item.set_script(chosen[1])
				if type == Permanente:
					item.add_to_group("rewind_prone")
					inventory.add_child(item)
				else:
					inventory.replace(2, item)
			KEY_L:
				var item := Item.new()
				item.set_script(chosen[2])
				if type == Permanente:
					item.add_to_group("rewind_prone")
					inventory.add_child(item)
				else:
					inventory.replace(3, item)
