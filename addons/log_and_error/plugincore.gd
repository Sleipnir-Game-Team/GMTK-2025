@tool
extends EditorPlugin

const LOGGER_SINGLETON = "Logger"

func _enter_tree() -> void:
	add_custom_type("ErrorScreen)","Node",
	preload("error_screen/error_screen.gd"),preload("res://assets/Icons/ErrorScreen.svg"))
	add_autoload_singleton(LOGGER_SINGLETON,"logger.gd")

func _exit_tree() -> void:
	remove_autoload_singleton(LOGGER_SINGLETON)
	remove_custom_type("ErrorScreen")
