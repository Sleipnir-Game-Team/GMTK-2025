class_name Ativo extends Item

var available: bool = true

func try_use() -> void:
	if available:
		use()
		available = false

func use() -> void:
	print("uhhh, you should override this")
