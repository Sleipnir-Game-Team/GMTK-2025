extends MarginContainer

var introText: String = "type|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|Every day adventurers raid and loot poor dungeons in search of treasure.\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|In search of the greatest known treasure, the Dungeon's Heart, the blasted adventurers decided to invade the magnificent living dungeon.\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|But what they didn't know is that the dungeon itself could grow.\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|Filling the path with traps to stop them\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|They think it will be easy to rob me\ntype|wait\ntype|img;url|res://Assets/GRAMMY__.png\ntype|txt;text|F O O L S ! !\ntype|wait\ntype|end"
var test_text: String = "type|img;content|res://Assets/GRAMMY__.png\ntype|name;content|Ice Cube\ntype|txt;content|Olá! Meu nome é Ice Cube, eu sou um negão de respeito, to preparado p mostrar a que eu vim, rexpeita fi\ntype|wait\ntype|end"
var cutsceneActions: Array = []
var dialogueActions: Array = []

func _ready() -> void:
	format_content(test_text, "dialogue")
	format_content(introText, "cutscene")
	UI_Controller.dialogue_request.connect(pass_dialogue)
	UI_Controller.scene_request.connect(pass_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print("managePauseMenu")
		$AudioPause.play()
		UI_Controller.managePauseMenu()
	#if event.is_action_pressed("win"):
		#GameManager.win_game()
	#if event.is_action_pressed("lose"):
		#GameManager.game_over()
	if event.is_action_pressed("dialogue"):
		UI_Controller.processAction("dialogue")
	if event.is_action_pressed("cutscene"):
		UI_Controller.processAction("cutscene")

func format_content(content: String, actionType: String) -> void:
	for linha in content.split("\n"):
		var linhaDividida := linha.split(";")
		var actionDict := {}
		for item: String in linhaDividida:
			var itemDividido := item.split("|")
			actionDict[itemDividido[0]] = itemDividido[1]
		if actionType == "cutscene":
			cutsceneActions.append(actionDict)
		else:
			dialogueActions.append(actionDict)

func pass_dialogue() -> void:
	#InkHandler.continue_story()
	UI_Controller.manage_dialogue_box.emit(dialogueActions.pop_front())

func pass_scene() -> void:
	UI_Controller.manage_cutscene_screen.emit(cutsceneActions.pop_front())
