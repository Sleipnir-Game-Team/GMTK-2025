extends Node

var rng := RandomNumberGenerator.new()

enum masks{
	PLAYER_MASK = 1
}

var cutscene = []

var tutorial = [
		{"type": "name", "content": "Dr. Macedo"},
		{"type": "img", "content": "res://assets/Dialogue/Png/Macedo_1.png"},
		{"type": "txt", "content": "I see that you coudn't get there yet"},
		{"type": "wait"},
		{"type": "name", "content": "G.A.R.U."},
		{"type": "img", "content": "res://assets/Dialogue/Png/Garu_sad.png"},
		{"type": "txt", "content": "Garu...."},
		{"type": "wait"},
		{"type": "name", "content": "Dr. Macedo"},
		{"type": "img", "content": "res://assets/Dialogue/Png/Macedo_2.png"},
		{"type": "txt", "content": "No need for sorry, we already predicted that your mission would be turbulent at best"},
		{"type": "wait"},
		{"type": "txt", "content": "Dr. Marocas worked in some improvement discs, it could assist you"},
		{"type": "wait"},
		{"type": "name", "content": "G.A.R.U."},
		{"type": "img", "content": "res://assets/Dialogue/Png/Garu_salute.png"},
		{"type": "txt", "content": "Garu!!"},
		{"type": "wait"},
		{"type": "name", "content": "Dr. Macedo"},
		{"type": "img", "content": "res://assets/Dialogue/Png/Macedo_1.png"},
		{"type": "txt", "content": "Finishing the discs is a hard work that takes time, thing that we don't have much"},
		{"type": "wait"},
		{"type": "img", "content": "res://assets/Dialogue/Png/Macedo_2.png"},
		{"type": "txt", "content": "So we will prepare some discs and let you decide which we finish"},
		{"type": "wait"},
		{"type": "img", "content": "res://assets/Dialogue/Png/Macedo_3.png"},
		{"type": "txt", "content": "The other ones we will keep working on for future repetitions"},
		{"type": "wait"},
		{"type": "name", "content": "G.A.R.U."},
		{"type": "img", "content": "res://assets/Dialogue/Png/Garu_sad.png"},
		{"type": "txt", "content": "Garu?"},
		{"type": "wait"},
		{"type": "name", "content": "Dr. Macedo"},
		{"type": "img", "content": "res://assets/Dialogue/Png/Macedo_3.png"},
		{"type": "txt", "content": "If you think some discs are useless you can just tell us and we will trash him and start working on another"},
		{"type": "wait"},
		{"type": "name", "content": "G.A.R.U."},
		{"type": "img", "content": "res://assets/Dialogue/Png/Garu_ok.png"},
		{"type": "txt", "content": "Garu"},
		{"type": "wait"},
		{"type": "name", "content": "Dr. Macedo"},
		{"type": "img", "content": "res://assets/Dialogue/Png/Macedo_3.png"},
		{"type": "txt", "content": "Okay, but choose fast, remember time is of the essence"},
		{"type": "wait"},
		{"type": "name", "content": "G.A.R.U."},
		{"type": "img", "content": "res://assets/Dialogue/Png/Garu_salute.png"},
		{"type": "txt", "content": "Garu!!!"},
		{"type": "wait"},
		{"type": "end"}
	]

## Quantas camadas de pause tem
##  0 - O jogo não está pausado
## +1 - O jogo está pausado por essa quantidade de fontes
var _pause_layers: int = 0:
	get:
		return _pause_layers
	set(value):
		_pause_layers = max(0, value)
		get_tree().paused = _pause_layers > 0

## Adiciona uma camada de pause
func pause() -> void:
	_pause_layers += 1
	Logger.info("Camada de pause adicionada, atualmente existem %s camadas" % [_pause_layers])

## Remove uma camada de pause
## ATENÇÃO: Utilizar essa função NÃO implica que o jogo será despausado
## Despausar o jogo exige que TODAS as camadas de pause sejam removidas
func resume() -> void:
	_pause_layers -= 1
	Logger.info("Camada de pause removida, atualmente existem %s camadas" % [_pause_layers])

func find_node(nodeName: String, parent: Node) -> Node:
	return get_node(str(parent.get_path()) + "/" + nodeName)

func win_game() -> void:
	UI_Controller.changeScreen("res://ui/menu/victory_menu.tscn", get_tree().root)
	
func game_over() -> void:
	UI_Controller.changeScreen("res://ui/menu/game_over_menu.tscn", get_tree().root)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.is_action("ui_accept"):
			progress_cutscene()

func save_game(buffs: Array[String]) -> void:
	var save_file := FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var game: Node = get_tree().get_first_node_in_group("game")
	var inventory := find_node("Player/Inventory", game)
	
	var data: Dictionary[String, Variant] = {
		"buffs": buffs,
		"inventory": inventory.get_children()
	}
	save_file.store_buffer(var_to_bytes_with_objects(data))

func load_game() -> void:
	var data: Dictionary[String, Variant] = bytes_to_var_with_objects(FileAccess.get_file_as_bytes("user://savegame.save"))
	
	var game: Node = get_tree().get_first_node_in_group("game")
	var inventory := find_node("Player/Inventory", game)
	
	var items = inventory.get_children()
	inventory.trigger_buffs(data.buffs)
	for index in range(4):
		var saved: Item = data.inventory[index]
		
		if saved != null:
			inventory.remove_child(items[index])
			saved.name = "%s" % [index+1]
			inventory.add_child(saved)

func start_game() -> void:
	UI_Controller.scene_end.connect(
		UI_Controller.openScreen.bind("res://main.tscn", get_tree().root)
		, ConnectFlags.CONNECT_ONE_SHOT)
	cutscene = [
		{"type": "txt", "text": "A.R.C.A. is a lab that uses atomic power to make all kinds of machinery"},
		{"type": "img", "url": "res://assets/Art assets/INTRO_1.jpg"},
		{"type": "wait"},
		{"type": "txt", "text": "Everything that doesn't work there is quickly trown into a dumpster"},
		{"type": "img", "url": "res://assets/Art assets/INTRO_2.jpg"},
		{"type": "wait"},
		{"type": "txt", "text": "Except that when they threw a time machine, the radiation made it work, but not in the intended way"},
		{"type": "img", "url": "res://assets/Art assets/INTRO_3.jpg"},
		{"type": "wait"},
		{"type": "txt", "text": "It teared repeatedly the fabric of time and turned the dumpster into a death room"},
		{"type": "wait"},
		{"type": "txt", "text": "The only one that can withstand the machine's radiation and save everyone is G.A.R.U."},
		{"type": "img", "url": "res://assets/Art assets/INTRO_4.jpg"},
		{"type": "wait"},
		{"type": "txt", "text": "Who is determined to complete any given mission."},
		{"type": "wait"},
		{"type": "end"},
	]
	UI_Controller.freeScreen()
	run_cutscene()
	
func run_cutscene():
	UI_Controller.processAction("cutscene")
	UI_Controller.scene_request.connect(progress_cutscene)
	progress_cutscene()

func progress_cutscene():
	var action = cutscene.pop_front()
	print(action)
	UI_Controller.manage_cutscene_screen.emit(action)

func start_run():
	if TimeWizard.rewind_count != 1:
		GameManager.resume()
	if TimeWizard.rewind_count != 0:
		var chosen = []
		var lista := ItemsList.ativo.duplicate() + ItemsList.consumivel.duplicate() + ItemsList.permanente.duplicate()
		chosen = []
		for i in range(3):
			var chosen_pos := rng.randi_range(0, lista.size()-1)
			chosen.append(lista.pop_at(chosen_pos))
		UI_Controller.processAction("augment", chosen)
		if TimeWizard.rewind_count == 1:
			var tutorial_copy = tutorial
			UI_Controller.dialogue_end.connect(GameManager.resume)
			UI_Controller.dialogue_request.connect(progress_dialogue)
			UI_Controller.processAction("dialogue")
			


func progress_dialogue():
	var action = tutorial.pop_front()
	UI_Controller.manage_dialogue_box.emit(action)


## Tenta carregar um save, se houver
func start_or_load_game() -> void:
	start_game()
	if FileAccess.file_exists("user://savegame.save"):
		load_game()

func delete_save() -> void:
	var dir := DirAccess.open("user://")
	
	if dir.file_exists("savegame.save"):
		dir.remove("savegame.save")
