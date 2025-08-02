extends PathFollow2D

@export var back_and_forth = true
@export var speed = 20

@export var direction = 1

func _physics_process(delta):
	var next = progress_ratio + (speed * delta * direction) / 100
	if next > 1 or next < 0:
		if back_and_forth:
			next -= (speed * delta * direction) / 100 * 2
			direction *= -1
		else:
			next -= direction
	progress_ratio = next
