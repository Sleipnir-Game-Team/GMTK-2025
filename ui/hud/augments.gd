extends Control

@onready var Augment_Left: TextureButton = get_node("%Augment_Left")
@onready var Augment_Middle: TextureButton = get_node("%Augment_Middle")
@onready var Augment_Right: TextureButton = get_node("%Augment_Right")
@onready var Discard_Button_Left: TextureButton = get_node("%Discard_Button_Left")
@onready var Discard_Button_Middle: TextureButton = get_node("%Discard_Button_Middle")
@onready var Discard_Button_Right: TextureButton = get_node("%Discard_Button_Right")
@onready var Augment_Left_Label: Label = get_node("%Augment_Left_Label")
@onready var Augment_Middle_Label: Label = get_node("%Augment_Middle_Label")
@onready var Augment_Right_Label: Label = get_node("%Augment_Right_Label")
var chosen_aguments: Array
var button_augments: Array
var button_labels: Array
var discarded_aguments: Array

func _ready():
	button_augments = [Augment_Left, Augment_Middle, Augment_Right]
	button_labels = [Augment_Left_Label, Augment_Middle_Label, Augment_Right_Label]
	place_aguments()
	
func _process(delta):
	if discarded_aguments.size() == 3:
		UI_Controller.freeScreen()

func manage_attributes(chosen) -> void:
	chosen_aguments = chosen

func place_aguments() -> void:
	for i in range(3):
		var augment = chosen_aguments[i].resource_path.get_file().split('.')[0]
		var button = button_augments[i]
		var label = button_labels[i]
		label.text = augment
		set_button_sprite(augment, button)

func set_button_sprite(augment: String, button: TextureButton) -> void:
	button.set_texture_normal(load("res://Assets/Bola_de_gas.png"))
	button.set_texture_hover(load("res://Assets/Lixao_sprite_sheet.png"))
	button.set_texture_pressed(load("res://Assets/GRAMMY__.png"))
	button.set_texture_disabled(load("res://Assets/lixos.png"))
	#button.set_texture_normal(load("res://Assets/%s_normal.png" % [augment]))
	#button.set_texture_hover(load("res://Assets/%s_hover.png" % [augment]))
	#button.set_texture_pressed(load("res://Assets/%s_pressed.png" % [augment]))
	#button.set_texture_disabled(load("res://Assets/%s_disabled.png" % [augment]))

func _on_discard_button_left_pressed():
	Discard_Button_Left.disabled = true
	Augment_Left.disabled = true
	var discarded = chosen_aguments[0]
	discarded_aguments.append(discarded)
	UI_Controller.discard_augment.emit(discarded)


func _on_discard_button_middle_pressed():
	Discard_Button_Middle.disabled = true
	Augment_Middle.disabled = true
	var discarded = chosen_aguments[1]
	discarded_aguments.append(discarded)
	UI_Controller.discard_augment.emit(discarded)


func _on_discard_button_right_pressed():
	Discard_Button_Right.disabled = true
	Augment_Right.disabled = true
	var discarded = chosen_aguments[2]
	discarded_aguments.append(discarded)
	UI_Controller.discard_augment.emit(discarded)


func _on_pass_button_pressed():
	UI_Controller.freeScreen()


func _on_augment_left_pressed():
	UI_Controller.select_augment.emit(chosen_aguments[0])
	UI_Controller.freeScreen()


func _on_augment_middle_pressed():
	UI_Controller.select_augment.emit(chosen_aguments[1])
	UI_Controller.freeScreen()


func _on_augment_right_pressed():
	UI_Controller.select_augment.emit(chosen_aguments[2])
	UI_Controller.freeScreen()
