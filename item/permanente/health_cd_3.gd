extends Permanente

func use() -> void:
	Effects.add_hp(player, self, 3)
