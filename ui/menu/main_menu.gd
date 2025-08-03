extends Control

func _ready() -> void:
	if SleipnirMaestro.current_song_node != null and SleipnirMaestro.current_song_node.is_playing():
		SleipnirMaestro.load_song("menu",true,0,false)
	else:
		SleipnirMaestro.load_song("menu",false,0,false)
		SleipnirMaestro.play()
	
	if FileAccess.file_exists("user://savegame.save"):
		$CanvasLayer/MarginContainer/Save.visible = true
		$CanvasLayer/MarginContainer/NoSave.visible = false
	else:
		$CanvasLayer/MarginContainer/Save.visible = false
		$CanvasLayer/MarginContainer/NoSave.visible = true
	
	UI_Controller.stack.screens.append(self)


## Função que roda quando você aperta o botão de "jogar"
## CONTINUA DE UM SAVE SE EXISTIR
func _on_play_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	GameManager.start_or_load_game()

## TODO ADICIONAR O BOTÃO
## DELETA O SAVE SE EXISTIR, INICIA UM JOGO NOVO
func _on_play_new_button_pressed() -> void:
	GameManager.delete_save()
	GameManager.start_game()


## Função que roda quando você aperta o botão de "opções"
func _on_options_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/options_menu.tscn", get_tree().root)
	
## Função que roda quando você aperta o botão de "opções"
func _on_credits_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/credits_menu.tscn", get_tree().root)

## Função que roda quando você aperta o botão de "sair"
func _on_quit_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	get_tree().quit() # Fecha a aplicação
