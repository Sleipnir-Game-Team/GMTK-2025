extends Node

signal rewind_finished

## Duração máxima em segundos do histórico de propriedades
const HISTORY_SECONDS: int = 30

## Quantos ticks são salvos por segundo (60 = Engine.physics_ticks_per_second)
const SAMPLE_HZ: int = 60

## O rewind é sempre pelo menos essa constante vezes mais rápido que o jogo normal
const MIN_REWIND_MULTIPLIER: float = 1.5

## Flag se está voltando o historico ou não
var _rewinding: bool = false

## Quantidade máxima de ticks no histórico
var _max_samples: int = HISTORY_SECONDS * SAMPLE_HZ

## Quantos frames usar por tick de rewind (1 = velocidade normal)
var _rewind_speed: float = 1.5
var _tick_budget: float = 0.0
var _use_duration: bool = false
var _duration_clamped: bool = false
var _rewind_deadline_msec: int = 0

## Histórico global.
## Cada elemento é um dicionário representando um tick do histórico.
## - Chaves: NodePath representando uma propriedade
## - Valor: Valor da propriedade representada na chave, naquele tick
var _samples: Array = []

## Indice do tick mais recente do histórico 
var _write_index: int = -1

## Quantidade de ticks válidos em memória
var _count: int = 0

## Variável auxiliar, para evitar a criação de múltiplos registros de histórico no mesmo frame
var _last_frame_id: int = -1

## Raiz do snapshot, tudo abaixo disso é resetado por padrão.
## Nós no grupo "rewind_prone" são deletados no reset mesmo que façam parte do snapshot.
## Nós no grupo "rewind_proof" não são resetados, e se mantém como já estão.
var origin_root: Node = null

## Dicionário que contém o snapshot do jogo
var origin_state: Dictionary[String, PackedByteArray] = {}

## Quantidade de resets ocorridos
var rewind_count: int = 0

## Vetor auxiliar para reaplicar efeitos de itens permanentes no jogador depois dele ser resetado.
var buff_capsule: Array[String] = []

func _ready() -> void:
	# Só processa quando pausado
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	_samples.resize(_max_samples)
	for i in _max_samples:
		_samples[i] = null
	
	rewind_finished.connect(_on_rewind_finished)

func _physics_process(delta: float) -> void:
	if not _rewinding:
		return
	
	if _count <= 0:
		_finish_rewind()
		return
	
	if _use_duration and not _duration_clamped:
		_rewind_speed = _speed_to_hit_deadline()
	
	_tick_budget += _rewind_speed
	
	var ticks := int(_tick_budget)
	if ticks <= 0:
		return
	if ticks > _count:
		ticks = _count
	
	var final_index := (_write_index - (ticks - 1) + _max_samples) % _max_samples
	_apply_history_tick(final_index)
	
	for i in range(ticks):
		var idx := (_write_index - i + _max_samples) % _max_samples
		_samples[idx] = null
	
	_write_index = (_write_index - ticks + _max_samples) % _max_samples
	_count -= ticks
	_tick_budget -= float(ticks)


#region REWIND (tick-por-tick)
func rewind(time_to_rewind: float = -1.0) -> void:
	GameManager.pause()
	_rewinding = true
	_tick_budget = 0.0
	_use_duration = false
	_duration_clamped = false

	if time_to_rewind > 0.0 and _count > 0:
		var physics_hz := float(Engine.physics_ticks_per_second)
		var desired_tpf := float(_count) / time_to_rewind / physics_hz
		var min_tpf := _min_ticks_per_frame()
	
		_duration_clamped = desired_tpf < min_tpf
		_rewind_speed = max(desired_tpf, min_tpf)
	
		_use_duration = not _duration_clamped
		_rewind_deadline_msec = Time.get_ticks_msec() + int(time_to_rewind * 1000.0)

	print(Time.get_ticks_msec() / 1000.0)

func _finish_rewind() -> void:
	_rewinding = false
	_tick_budget = 0.0
	_use_duration = false
	_duration_clamped = false
	print(Time.get_ticks_msec() / 1000.0)
	rewind_finished.emit()

## Cada nó "PropertyHistory" chama essa função para salvar seus dados na historia global.
## Usamos um único dicionário por physics_frame, mesmo que a função seja chamada múltipla vezes.
func add_sample(prop_path: NodePath, value: Variant) -> void:
	var frame := Engine.get_physics_frames()
	if frame != _last_frame_id:
		_last_frame_id = frame
		_write_index = (_write_index + 1) % _max_samples
		_samples[_write_index] = {}
		if _count < _max_samples:
			_count += 1
	
	var cur: Dictionary = _samples[_write_index]
	cur[prop_path] = value

func _on_rewind_finished() -> void:
	restore()
	GameManager.resume()

func _apply_history_tick(index: int) -> void:
	# Apenas aplica (sem mexer em índices/contadores)
	var step: Dictionary = _samples[index]
	if step != null:
		for key: NodePath in step:
			var result := get_node_and_resource(key)
			var node: Node = result[0]
			var property_path: NodePath = result[2]
			if node and property_path != ^"":
				node.set_indexed(property_path, step[key])
#endregion

#region REWIND TIMING
func _baseline_ticks_per_frame() -> float:
	# 1× playback = samples consumed at the rate they were recorded
	return float(SAMPLE_HZ) / float(Engine.physics_ticks_per_second)

func _min_ticks_per_frame() -> float:
	return MIN_REWIND_MULTIPLIER * _baseline_ticks_per_frame()

func _speed_to_hit_deadline() -> float:
	var ms_left := _rewind_deadline_msec - Time.get_ticks_msec()
	if ms_left <= 0:
		# We’re late: finish this frame.
		return 1e9
	var seconds_left := float(ms_left) / 1000.0
	var physics_hz := float(Engine.physics_ticks_per_second)
	var desired_tpf := float(_count) / seconds_left / physics_hz
	return max(desired_tpf, _min_ticks_per_frame())

#endregion

#region SNAPSHOT/RESTORE (reset imediato)
func snapshot(root: Node) -> void:
	origin_root = root
	pack(root, origin_state)

func restore() -> void:
	if origin_root == null:
		return
	rewind_count += 1
	
	var group_capsule: Dictionary[String, Array] = {}
	var time_capsule: Dictionary[String, PackedByteArray] = {}
	var rewind_proof_nodes := get_tree().get_nodes_in_group("rewind_proof")
	for node in rewind_proof_nodes:
		pack(node, time_capsule)
		group_capsule[node.get_path().get_concatenated_names()] = node.get_groups()
	
	for child in origin_root.get_children():
		origin_root.remove_child(child)
		child.queue_free()
	
	var new_present := unpack(origin_state, time_capsule, group_capsule)
	for child in new_present.get_children():
		child.reparent(origin_root)
	new_present.queue_free()

func pack(start: Node, main: Dictionary[String, PackedByteArray]) -> void:
	main[start.get_path().get_concatenated_names()] = var_to_bytes_with_objects(start)
	for child in start.get_children():
		if child.is_in_group("rewind_prone"):
			continue
		pack(child, main)

func unpack(main: Dictionary[String, PackedByteArray],
			time_capsule: Dictionary[String, PackedByteArray],
			group_capsule: Dictionary[String, Array]) -> Node:
	var nodes_pile: Array[Node] = []
	var path_pile: Array[NodePath] = []
	
	var keys := main.keys()
	keys.reverse()
	
	for key: String in keys:
		var path := NodePath(key)
		var node_to_use := time_capsule if time_capsule.has(key) else main
		var node: Node = bytes_to_var_with_objects(node_to_use[key])
		node.name = path.get_name(path.get_name_count() - 1)
		node.unique_name_in_owner = bytes_to_var_with_objects(main[key]).unique_name_in_owner
		node.owner = bytes_to_var_with_objects(main[key]).owner
		
		if group_capsule.has(key):
			for group: StringName in group_capsule.get(key):
				if not str(group).begins_with("_"):
					node.add_to_group(group)
		
		while nodes_pile.size() > 0 and path == path_pile.back().slice(0, -1):
			node.add_child(nodes_pile.pop_back())
			path_pile.pop_back()
		
		nodes_pile.push_back(node)
		path_pile.push_back(path)
	
	return nodes_pile.pop_back()
#endregion

#region AUXILIAR DE ITENS PERMANENTES
func load_buff() -> Array[String]:
	var dup := buff_capsule.duplicate()
	buff_capsule = []
	return dup

func save_buff(buff_script: String) -> void:
	buff_capsule.append(buff_script)
#endregion
