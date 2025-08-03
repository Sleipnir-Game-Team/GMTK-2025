extends Control

@onready var health_bar: HBoxContainer = get_node("%Health_Bar")
var max_health
var current_life

func _ready():
	GameManager.find_node("Game/Player/Signalizer", get_parent()).cure_received.connect(heal_life)
	GameManager.find_node("Game/Player/Signalizer", get_parent()).damage_received.connect(hurt_life)
	max_health = GameManager.find_node("Game/Player/Life", get_parent()).max_life
	current_life = GameManager.find_node("Game/Player/Life", get_parent()).entity_life
	GameManager.find_node("Game/Player/Inventory", get_parent()).inventory_place_button.connect(place_item)
	populate_health_bar(health_bar, max_health)
	
func populate_health_bar(health_bar, max_health) -> void:
	for i in range(max_health):
		var new_heart = TextureRect.new()
		new_heart.texture = load("res://Assets/Art assets/Life_bar.png")
		health_bar.add_child(new_heart)

func heal_life(dealer, value) -> void:
	print(value)
	for i in range(value):
		var new_heart = TextureRect.new()
		new_heart.texture = load("res://Assets/Art assets/Life_bar.png")
		print(health_bar.get_children())
		health_bar.add_child(new_heart)

func hurt_life(dealer, value) -> void:
	print(value)
	for i in range(value):
		print("dano")
		if value <= health_bar.get_child_count():
			health_bar.get_children()[-1].queue_free()

func place_item(item):
	var item_box = VBoxContainer.new()
	var item_label = Label.new()
	var item_key = item.key
	var item_sprite = item.sprite
