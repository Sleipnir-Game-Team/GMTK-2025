extends MarginContainer

@onready var keybinding_list: VBoxContainer = get_node("%keybinding_list")
@onready var input_button_scene: = preload("res://ui/buttons/input_button.tscn")
var is_remapping: = false
var action_to_remap: Variant = null
var remapping_button: Variant = null
var keybinding_settings: Dictionary = Config_Handler.load_all_keybinding_settings()
var action_formatted_dict: Dictionary = format_actions()

func _ready() -> void:
	var equal: bool = compare_input_mapping()
	if !equal:
		create_action_list()
	else:
		update_action_list()

func compare_input_mapping() -> bool:
	var equal: bool = true
	var count: int = 0
	while (equal && count < action_formatted_dict.keys().size()):
		var new_action: String = action_formatted_dict.keys()[count]
		if typeof(InputMap.action_get_events(new_action)[0]) != typeof(keybinding_settings[new_action]):
			equal = false
		count += 1
	return equal

func update_action_list() -> void:
	for item in keybinding_list.get_children():
		item.queue_free()
		
	for action:String in action_formatted_dict:
		var button := input_button_scene.instantiate()
		var action_label := button.find_child("action_label")
		var input_label := button.find_child("input_label")
		action_label.text = action_formatted_dict[action]
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybinding_settings[action])
		var events := InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
			Config_Handler.save_keybinding_settings(action, events[0])
		else:
			input_label.text = ""
		
		keybinding_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func create_action_list() -> void:
	InputMap.load_from_project_settings()
	for item in keybinding_list.get_children():
		item.queue_free()
		
	for action: String in action_formatted_dict:
		var button := input_button_scene.instantiate()
		var action_label := button.find_child("action_label")
		var input_label := button.find_child("input_label")
		action_label.text = action_formatted_dict[action]
		var events := InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
			Config_Handler.save_keybinding_settings(action, events[0])
		else:
			input_label.text = ""
		
		keybinding_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func format_actions() -> Dictionary:
	var action_dict := {}
	for item in keybinding_settings.keys():
		match item:
			"pause":
				action_dict[item] = "Pause"
			"win":
				action_dict[item] = "Win the game"
			"lose":
				action_dict[item] = "Lose the game"
	return action_dict


func _on_input_button_pressed(button: Node, action: String) -> void:
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("input_label").text = "Escolha a tecla..."


func _input(event: InputEvent) -> void:
	if is_remapping:
		if (event is InputEventKey && event.pressed) || (event is InputEventMouseButton && event.pressed):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			var key_already_bind: String = check_bind(event)
			if key_already_bind == "none":
				InputMap.action_erase_events(action_to_remap)
				InputMap.action_add_event(action_to_remap, event)
				_update_input_button(remapping_button, event)
				is_remapping = false
				action_to_remap = null
				remapping_button = null
				accept_event()
			else:
				var input_label: Label = remapping_button.find_child("input_label")
				var events: = InputMap.action_get_events(action_to_remap)
				if events.size() > 0:
					input_label.text = events[0].as_text().trim_suffix(" (Physical)")
				is_remapping = false
				action_to_remap = null
				remapping_button = null
				accept_event()
				#var attributes: Dictionary = {}
				#attributes["Tipo"] = "Erro de mapeamento"
				#attributes["Mensagem"] = "Erro no mapeamento, a tecla '%s' já está mapeada para a função '%s'"%[event.as_text().trim_suffix(" (Physical)"), action_formatted_dict[key_already_bind]]
				#UI_Controller.openScreen("res://ui/error/error_screen.tscn", get_tree().root, attributes)
				var type: String = "Erro de mapeamento"
				var msg: String = "Erro no mapeamento, a tecla '%s' já está mapeada para a função '%s'"%[event.as_text().trim_suffix(" (Physical)"), action_formatted_dict[key_already_bind]]
				Logger.load_error_screen(type, msg)

func check_bind(event: InputEvent) -> String:
	for action:String in keybinding_settings.keys():
		if InputMap.action_has_event(action, event) and action_to_remap != action:
			return action
	return "none"


func _update_input_button(button: Node, event: InputEvent) -> void:
	button.find_child("input_label").text = event.as_text().trim_suffix(" (Physical)")
	Config_Handler.save_keybinding_settings(action_to_remap, event)

func _on_reset_button_pressed() -> void:
	keybinding_settings = Config_Handler.load_all_keybinding_settings()
	create_action_list()
