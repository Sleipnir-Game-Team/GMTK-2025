extends Control

@export var pessoas: Array[Resource]

func _ready():
	for pessoa in pessoas:
		var ficha = load("res://ui/ficha.tscn").instantiate()
		ficha.info = pessoa
		%Grade.add_child(ficha)

func _on_back_button_pressed() -> void:
	AudioManager.play_global("ui.screen.back")
	UI_Controller.freeScreen()
