extends MarginContainer

var introText: String = "type|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|Every day adventurers raid and loot poor dungeons in search of treasure.\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|In search of the greatest known treasure, the Dungeon's Heart, the blasted adventurers decided to invade the magnificent living dungeon.\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|But what they didn't know is that the dungeon itself could grow.\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|Filling the path with traps to stop them\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|They think it will be easy to rob me\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|F O O L S ! !\ntype|wait\ntype|end"
var test_text: String = "type|img;content|res://assets/ice_cube.png\ntype|name;content|Ice Cube\ntype|txt;content|Olá! Meu nome é Ice Cube, eu sou um negão de respeito, to preparado p mostrar a que eu vim, rexpeita fi\ntype|wait\ntype|end"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print("managePauseMenu")
		UI_Controller.managePauseMenu()
	#if event.is_action_pressed("win"):
		#GameManager.win_game()
	#if event.is_action_pressed("lose"):
		#GameManager.game_over()
	if event.is_action_pressed("dialogue"):
		UI_Controller.processAction({"Content": test_text}, "dialogue")
	if event.is_action_pressed("cutscene"):
		UI_Controller.processAction({"Content": introText}, "cutscene")
