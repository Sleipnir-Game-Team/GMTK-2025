class_name Permanente extends Item

func _ready():
	use()
	queue_free()

func use():
	print("uhhh, you should override this")
