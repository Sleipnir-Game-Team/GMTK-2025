extends Node


func _ready() -> void:
	TimeWizard.snapshot(self)

func _enter_tree() -> void:
	print("Connecting child added")
	child_entered_tree.connect(_child_added)

func _child_added(child: Node) -> void:
	if child is Timer:
		print("Child has been added, connecting rewind")
		child.start()
		print(child.time_left)
		child.timeout.connect(TimeWizard.rewind)
