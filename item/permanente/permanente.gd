class_name Permanente extends Item

func _ready():
	TimeWizard.save_buff(get_script().resource_path)
	use()
	queue_free()

func use():
	print("uhhh, you should override this")
