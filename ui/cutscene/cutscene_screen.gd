extends Control

@onready var scene_image_texturerect: TextureRect = get_node("%scene_image")
@onready var scene_text_label: RichTextLabel = get_node("%scene_text")
@onready var info : String
var actions: Array = []

func _ready():
	UI_Controller.manage_cutscene_screen.connect(manage_scene)
	SceneRequest()

func manage_scene(action: Dictionary) -> void:
	match action.type:
		"img":
			updateCutsceneImg(action.url)
			SceneRequest()
		"txt":
			updateCutsceneTxt(action.text)
			SceneRequest()
		"wait":
			pass
		"end":
			UI_Controller.freeScreen()
			UI_Controller.scene_end.emit()


func SceneRequest() -> void:
	UI_Controller.scene_request.emit()
	
func SceneEnd() -> void:
	UI_Controller.scene_end.emit()

func updateCutsceneImg(image: String) -> void:
	%scene_image.texture = load(image)
	
func updateCutsceneTxt(text: String) -> void:
	%scene_text.text = text

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		if event.is_pressed():
			SceneRequest()
