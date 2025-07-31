extends Area2D

@onready var maximumSize = abs($End.position.y)
@onready var minimumSize = $Collision.shape.size.y

@export var quick_speed = 1200
@export var slow_speed = 50

var direction = 1

func _process(delta):
	if ($Collision.shape.size.y < minimumSize and direction == -1 
		or $Collision.shape.size.y > maximumSize and direction == 1):
		direction *= -1
	if $Collision.shape.size.y < minimumSize + 100:
		$Collision.shape.size.y += slow_speed * delta * direction
	else:
		$Collision.shape.size.y += quick_speed * delta * direction
	$Collision.position.y = $Collision.shape.size.y/2
