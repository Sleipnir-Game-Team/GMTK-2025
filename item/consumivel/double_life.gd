extends Consumivel

func use() -> void:
	Effects.overheal(player, self, 2)
