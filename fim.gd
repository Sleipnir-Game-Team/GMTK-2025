extends Area2D

var good_end = [
	{"type": "txt", "text": "On return to the lab, G.A.R.U. was received with praises"},
	{"type": "img", "url": "res://assets/Art assets/ENDING_2A.jpg"},
	{"type": "wait"},
	{"type": "txt", "text": "He was awarded by the scientists as the great time hero"},
	{"type": "wait"},
	{"type": "txt", "text": "GOOD ENDING"},
	{"type": "wait"},
	{"type": "end"}
]

var normal_end = [
	{"type": "txt", "text": "On return to the lab G.A.R.U saw the scientists worried"},
	{"type": "img", "url": "res://assets/Art assets/ENDING_2B.jpg"},
	{"type": "wait"},
	{"type": "txt", "text": '"Time is fixed, but the impact is already done" they said'},
	{"type": "wait"},
	{"type": "txt", "text": 'G.A.R.U. just went on serving coffee, knowing well that they would solve the problem eventually'},
	{"type": "wait"},
	{"type": "txt", "text": "NEUTRAL ENDING"},
	{"type": "wait"},
	{"type": "end"}
]

var bad_end = [
	{"type": "txt", "text": "On return to the lab G.A.R.U. saw the scientists frozen"},
	{"type": "img", "url": "res://assets/Art assets/ENDING_2C.jpg"},
	{"type": "wait"},
	{"type": "txt", "text": "They were up, with their eyes wide open, but no sound exited their mouths"},
	{"type": "wait"},
	{"type": "txt", "text": "G.A.R.U. stayed there waiting for his next order"},
	{"type": "img", "url": "res://assets/Art assets/ENDING_3C.jpg"},
	{"type": "wait"},
	{"type": "txt", "text": "It never came"},
	{"type": "wait"},
	{"type": "txt", "text": "BAD ENDING"},
	{"type": "wait"},
	{"type": "end"}
]

func _ready():
	body_entered.connect(on_body_entered)
	
func on_body_entered(body):
	GameManager.delete_save()
	UI_Controller.scene_end.connect(
		UI_Controller.openScreen.bind("res://ui/menu/main_menu.tscn", get_tree().root)
	,ConnectFlags.CONNECT_ONE_SHOT)
	var end = [
		{"type": "txt", "text": "The time machine was turned off and the fabric of time was saved"},
		{"type": "img", "url": "res://assets/Art assets/ENDING_1.jpg"},
		{"type": "wait"},
		{"type": "wait"}
	]
	match TimeWizard.world_state:
		0:
			end += good_end
		1:
			end += normal_end
		2:
			end += bad_end
	GameManager.cutscene = end
	UI_Controller.freeScreen()
	GameManager.run_cutscene()
	
