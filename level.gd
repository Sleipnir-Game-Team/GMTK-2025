extends Node

var rewind_time: float = 5
var rewind_invocation: Callable = TimeWizard.rewind.bind(rewind_time)

func _ready() -> void:
	match SleipnirMaestro.load_song("level",true):
		OK:
			pass
		_:
			pass
	TimeWizard.snapshot(self)

func _enter_tree() -> void:
	child_entered_tree.connect(_child_added)

func _child_added(child: Node) -> void:
	if child is Timer:
		print("Child has been added, connecting rewind")
		child.start(TimeWizard.level_time_limit)
		child.timeout.connect(rewind_invocation)
	elif child.name == "Player":
		GameManager.find_node("Life", child).death.connect(rewind_invocation)
