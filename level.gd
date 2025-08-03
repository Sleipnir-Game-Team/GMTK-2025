extends Node

var rewind_time: float = 5
var rewind_invocation: Callable = TimeWizard.rewind.bind(rewind_time)

func _ready() -> void:
	TimeWizard.snapshot(self)

func _enter_tree() -> void:
	child_entered_tree.connect(_child_added)

func _child_added(child: Node) -> void:
	if child is Timer:
		print("Child has been added, connecting rewind")
		child.start()
		child.timeout.connect(rewind_invocation)
