class_name Item extends Node

@onready var player = get_parent().get_parent()

func try_use():
	print("slot vazio")
