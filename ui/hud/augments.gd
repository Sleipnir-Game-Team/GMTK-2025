extends Control

@onready var Augment_Left: TextureButton = $CanvasLayer/MarginContainer/VBoxContainer/Augment_Box/aug_panel/Left_Augment_Container/Augment_Left
@onready var Augment_Middle: TextureButton = get_node("%Augment_Middle")
@onready var Augment_Right: TextureButton = get_node("%Augment_Right")
@onready var Discard_Button_Left: TextureButton = get_node("%Discard_Button_Left")
@onready var Discard_Button_Middle: TextureButton = get_node("%Discard_Button_Middle")
@onready var Discard_Button_Right: TextureButton = get_node("%Discard_Button_Right")
@onready var Augment_Left_Label: Label = get_node("%Augment_Left_Label")
@onready var Augment_Middle_Label: Label = get_node("%Augment_Middle_Label")
@onready var Augment_Right_Label: Label = get_node("%Augment_Right_Label")
@onready var Augment_Left_Description: Label = get_node("%Augment_Left_Description")
@onready var Augment_Middle_Description: Label = get_node("%Augment_Middle_Description")
@onready var Augment_Right_Description: Label = get_node("%Augment_Right_Description")
var chosen_aguments: Array
var button_augment_sprites: Array
var button_labels: Array
var button_descriptions: Array
var discarded_aguments: Array

func _ready():
	Augment_Left.pressed.connect(_on_augment_left_pressed)
	Augment_Middle.pressed.connect(_on_augment_middle_pressed)
	
	button_augment_sprites = [Augment_Left, Augment_Middle, Augment_Right]
	button_labels = [Augment_Left_Label, Augment_Middle_Label, Augment_Right_Label]
	button_descriptions = [Augment_Left_Description, Augment_Middle_Description, Augment_Right_Description]
	place_aguments()
	
	
func teste():
	print("teste")

func _process(delta):
	if discarded_aguments.size() == 3:
		UI_Controller.freeScreen()

func manage_attributes(chosen) -> void:
	chosen_aguments = chosen

func place_aguments() -> void:
	for i in range(3):
		button_labels[i].text = chosen_aguments[i].name
		#button_augment_sprites[i].texture = load(chosen_aguments[i].images)
		set_sprites(button_augment_sprites[i], chosen_aguments[i].images)
		button_descriptions[i].text = chosen_aguments[i].description

func set_sprites(button: TextureButton, images: Dictionary) -> void:
	button.texture_normal = images["normal"]
	button.texture_hover = images["hover"]
	button.texture_pressed = images["pressed"]
	button.texture_disabled = images["disabled"]

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
