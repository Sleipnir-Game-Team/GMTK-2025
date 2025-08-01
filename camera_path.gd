extends PathFollow2D

func _process(delta):
	var point = get_parent().curve.get_closest_offset(GameManager.find_node("Player", get_parent().get_parent()).position)
	progress = point
