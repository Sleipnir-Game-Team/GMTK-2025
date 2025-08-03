extends Node

@export var damage: int = 1
@onready var parent: Area2D = get_parent()
@onready var data: Dictionary[String, Variant] = {
	"damage": damage,
	"interactiveEffects": [Effects.damage.bind(parent, damage)]
}

func _physics_process(_delta: float) -> void:
	for body in parent.get_overlapping_bodies():
		var receiver: Node = GameManager.find_node("Receiver", body)
		receiver.receive(data)
