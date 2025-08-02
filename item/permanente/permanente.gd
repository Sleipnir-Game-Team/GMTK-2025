class_name Permanente extends Item

func _ready() -> void:
	TimeWizard.save_buff(get_script().resource_path)
	use()
	queue_free()

func use() -> void:
	print("uhhh, you should override this")
