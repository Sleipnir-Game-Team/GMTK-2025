extends Permanente

func use():
	Effects.add_hp(player, self, 1)
