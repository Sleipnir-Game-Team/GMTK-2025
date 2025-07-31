extends Node

@export var damage = 1

func _on_parent_body_entered(body):
	if body.has_node("Receiver"):
		var receiver = GameManager.find_node("Receiver", body)
		
		var data = {}
		data.damage = damage
		
		data.interactiveEffects = [
			Effects.damage.bind(get_parent(), data.damage),
		]
		
		receiver.receive(data)
