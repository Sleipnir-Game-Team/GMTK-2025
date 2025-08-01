extends Control

@onready var scene_image_texturerect: TextureRect = get_node("%scene_image")
@onready var scene_text_label: RichTextLabel = get_node("%scene_text")
@onready var info : String
var actions = []

func _ready():
	UI_Controller.next_cutScene_request.connect(manage_scene)

func manage_attributes(attributes: Variant) -> void:
	format_content(attributes["Content"])

func format_content(content: String) -> void:
	for linha in content.split("\n"):
		var linhaDividida = linha.split(";")
		var actionDict = {}
		for item in linhaDividida:
			var itemDividido = item.split("|")
			actionDict[itemDividido[0]] = itemDividido[1]
		actions.append(actionDict)

func manage_scene() -> void:
	var action = actions.pop_front()
	print("tipo: ", action.type)
	match action.type:
		"img":
			print("image: ", action.url)
			updateCutsceneImg(action.url)
			onSceneRequest()
		"txt":
			updateCutsceneTxt(action.text)
			onSceneRequest()
		"wait":
			pass
		"end":
			UI_Controller.freeScreen()


func onSceneRequest() -> void:
	UI_Controller.next_cutScene_request.emit()

func updateCutsceneImg(image: String) -> void:
	%scene_image.texture = load(image)
	
func updateCutsceneTxt(text: String) -> void:
	%scene_text.text = text

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		if event.is_pressed():
			onSceneRequest()
