class_name ErrorScreen extends Node

@export var ErrorMessage : Label

func _ready() -> void: get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().quit()
