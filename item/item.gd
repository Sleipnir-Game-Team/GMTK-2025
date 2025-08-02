class_name Item extends Node

@onready var player: Node2D = get_parent().get_parent()

func try_use() -> void:
	print("slot vazio")
