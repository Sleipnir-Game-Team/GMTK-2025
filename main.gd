extends MarginContainer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		UI_Controller.managePauseMenu()
	if event.is_action_pressed("win"):
		GameManager.win_game()
	if event.is_action_pressed("lose"):
		GameManager.game_over()
