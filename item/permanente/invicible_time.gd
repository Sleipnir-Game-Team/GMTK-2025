extends Permanente

func use() -> void:
	Effects.increase_invicibility(player, self, 0.5)
