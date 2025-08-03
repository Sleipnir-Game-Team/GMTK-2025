class_name Permanente extends Item

func _ready() -> void:
	var path: String = get_script().resource_path
	print("Permanente ativado: %s" % path)
	TimeWizard.save_buff(path)
	use()
	queue_free()

func use() -> void:
	print("uhhh, you should override this")
