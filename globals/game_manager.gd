extends Node

enum masks{
	PLAYER_MASK = 1
}

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

func start_or_load_game() -> void:
	UI_Controller.changeScreen("res://main.tscn", get_tree().root)
	if FileAccess.file_exists("user://savegame.save"):
		load_game()
