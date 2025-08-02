extends Area2D

@onready var maximumSize: float = abs($End.position.y)
@onready var minimumSize: float = $Collision.shape.size.y

@export var quick_speed: float = 1200
@export var slow_speed: float = 200

var speed: float = 0

var direction: int = 1

func _process(delta: float) -> void:
	var shape_size: float = $Collision.shape.size.y
	if (shape_size < minimumSize and direction == -1 
		or shape_size > maximumSize and direction == 1):
		direction *= -1
		AudioManager.play_global("level.danger.smasher")
	if shape_size < 0.25 * maximumSize:
		speed = slow_speed
	else:
		speed = quick_speed
	$Collision.shape.size.y += speed * delta * direction
	$Collision.position.y = $Collision.shape.size.y/2
