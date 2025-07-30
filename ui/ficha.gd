extends MarginContainer

@export var info: Resource

func _ready():
	%Name.text = info.name
	for function in info.function:
		if %Function.text.to_lower() != "placeholder":
			%Function.text += ", "
		else:
			%Function.text = ""
		%Function.text += function
	%Contact.text = info.contact
	%PFP.texture = info.pfp
