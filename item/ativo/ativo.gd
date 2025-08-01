class_name Ativo extends Item

var avaible = true

func try_use():
	if avaible:
		use()
		avaible = false

func use():
	print("uhhh, you should override this")
