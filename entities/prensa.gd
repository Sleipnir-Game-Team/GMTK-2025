extends Area2D

@onready var maximumSize = abs($End.position.y)
@onready var minimumSize = $Collision.shape.size.y

@export var quick_speed = 1200
@export var slow_speed = 200

var speed = 0

var direction = 1

func _process(delta):
	var shape_size = $Collision.shape.size.y
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
