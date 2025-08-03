extends Permanente

func use() -> void:
	Effects.increase_speed(player, self, 100)
