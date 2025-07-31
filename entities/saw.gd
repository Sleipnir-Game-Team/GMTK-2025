extends Area2D

@export var damage = 1

func _on_body_entered(body):
	if body.has_node("Receiver"):
		var receiver = GameManager.find_node("Receiver", body)
		
		var data = {}
		data.damage = damage
		
		data.interactiveEffects = [
			Effects.damage.bind(self, data.damage),
		]
		
		receiver.receive(data)
