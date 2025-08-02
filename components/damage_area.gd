extends Node

@export var damage: int = 1

func _ready() -> void:
	var parent: Area2D = get_parent()
	parent.body_entered.connect(_on_parent_body_entered)

func _on_parent_body_entered(body: Node) -> void:
	if body.has_node("Receiver"):
		var receiver: Node = GameManager.find_node("Receiver", body)
		
		var data: Dictionary[String, Variant] = {}
		data.damage = damage
		
		data.interactiveEffects = [
			Effects.damage.bind(get_parent(), data.damage),
		]
		
		receiver.receive(data)
