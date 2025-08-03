extends Consumivel

func use() -> void:
	Effects.trigger_invicibility(player, self, 1.5)
