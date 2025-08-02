extends PathFollow2D

@export var back_and_forth: bool = true
@export var speed: float = 20

@export var direction: int = 1

func _physics_process(delta: float) -> void:
	var next := progress_ratio + (speed * delta * direction) / 100
	if next > 1 or next < 0:
		if back_and_forth:
			next -= (speed * delta * direction) / 100 * 2
			direction *= -1
		else:
			next -= direction
	progress_ratio = next
