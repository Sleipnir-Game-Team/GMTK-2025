extends Node


func receive(data: Dictionary) -> void:
	if data.has("interactiveEffects"):
		for effect: Callable in data.interactiveEffects:
			effect.call(get_parent())
	if data.has("effects"):
		for effect: Callable in data.effects:
			effect.call()
