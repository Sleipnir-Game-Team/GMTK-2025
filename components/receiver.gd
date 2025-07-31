extends Node


func receive(data):
	if data.has("interactiveEffects"):
		for effect in data.interactiveEffects:
			effect.call(get_parent())
	if data.has("effects"):
		for effect in data.effects:
			effect.call()
