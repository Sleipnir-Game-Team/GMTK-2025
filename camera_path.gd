extends PathFollow2D

func _process(_delta: float) -> void:
	var point: float = (get_parent() as Path2D).curve.get_closest_offset(GameManager.find_node("Player", get_parent().get_parent()).position as Vector2)
	progress = point
