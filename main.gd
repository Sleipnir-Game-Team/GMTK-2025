extends MarginContainer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print("managePauseMenu")
		$AudioPause.play()
		UI_Controller.managePauseMenu()
