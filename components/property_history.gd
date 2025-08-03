extends Node
class_name PropertyHistory

## List of properties to record, as NodePaths that include the property after a colon.
## - Relativo: ^"..:position", ^"../Player/Life:max_health"
## - Absoluto: ^"/root/Main/Player:global_position"
@export var property_paths: Array[NodePath] = []

## { node: Node, subpath: NodePath, abs_key: NodePath }
var _targets: Array[Dictionary] = []

func _ready() -> void:
	_build_targets()
	print(_targets)

func _physics_process(_delta: float) -> void:
	for t in _targets:
		var node: Node = t.node
		if node:
			var sub: NodePath = t.subpath
			var value: Variant = node.get_indexed(sub)
			TimeWizard.add_sample(t.abs_key, value)

func _build_targets() -> void:
	_targets.clear()
	
	for p: NodePath in property_paths:
		var res := get_node_and_resource(p)
		var node: Node = res[0]
		var sub: NodePath = res[2] 
		
		if node == null:
			push_warning("PropertyHistory: Node não encontrado '%s' (relativo a %s)." % [str(p), str(get_path())])
			continue
		if sub == ^"":
			push_warning("PropertyHistory: Path '%s' não indica uma propriedade (use 'Node:propriedade')." % [str(p)])
			continue
		
		_targets.append(
			{
				"node": node,
				"subpath": sub,
				"abs_key": p if p.is_absolute() else NodePath(str(node.get_path()) + str(sub))
			}
		)
