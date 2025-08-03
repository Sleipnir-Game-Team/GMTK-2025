extends Control

@onready var health_bar: TextureProgressBar = get_node("%Health_Bar")
var max_health
var current_life

func _ready():
	GameManager.find_node("Game/Player/Signalizer", get_parent()).cure_received.connect(heal_life)
	GameManager.find_node("Game/Player/Signalizer", get_parent()).damage_received.connect(hurt_life)

func heal_life(dealer, value) -> void:
	print(value)
	health_bar.value += value

func hurt_life(dealer, value) -> void:
	print(value)
	health_bar.value -= value
