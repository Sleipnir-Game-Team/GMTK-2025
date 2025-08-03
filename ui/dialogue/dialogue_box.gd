extends Control

@onready var info : String
@onready var speaker_sprite_texturerect: TextureRect = get_node("%speaker_image")
@onready var speaker_name_label: Label = get_node("%speaker_name")
@onready var speech_richlabel: RichTextLabel= get_node("%speech")
var speech: String
var actions: Array = []
@onready var timer: Timer = get_node("%speech_velocity_timer")

func _ready():
	UI_Controller.manage_dialogue_box.connect(manage_dialogue)
	#InkHandler.data_line.connect(manage_dialogue)
	on_dialogue_request()
	#timer.wait_time = tempo
	timer.start()

func manage_dialogue(action: Dictionary) -> void:
	match action.type:
		"name":
			updateSpeakerName(action.content)
			on_dialogue_request()
		"img":
			updateSpeakerImg(action.content)
			on_dialogue_request()
		"txt":
			if timer.timeout.is_connected(write_speech):
				timer.timeout.disconnect(write_speech)
			timer.timeout.connect(write_speech.bind(action.content))
			on_dialogue_request()
		"choice":
			pass #content = dict chave->id escolhas content->escolhas
		"voice":
			pass
		"wait":
			pass
		"end":
			UI_Controller.freeScreen()
			UI_Controller.dialogue_end.emit()

func on_dialogue_request() -> void:
	UI_Controller.dialogue_request.emit()

func updateSpeakerImg(image: String) -> void:
	%speaker_image.texture = load(image)
	
func updateSpeakerName(name: String) -> void:
	%speaker_name.text = name

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		if event.is_pressed():
			on_dialogue_request()

func write_speech(text: String) -> void:
	%speech.text = text
	#.substr(0, len(speech) + 1)
	#%speech.text = speech
	#if %speech.text == text:
		#timer.timeout.disconnect(write_speech)
