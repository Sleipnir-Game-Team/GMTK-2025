extends Ativo

func use() -> void:
	Effects.add_double_jump(player, self, 1)
