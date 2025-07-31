class_name Life
extends Node

@export var max_life: int = 3
@export var can_exceed_max:= false
@onready var entity_life: int = max_life

@export var on_hit_invecibility_time:= 1
var invecibility_timer: Timer
var invincibility: bool = false

signal death
signal invecibility_end

signal damage_received(damage: int)
signal healing_received(heal: int)


func _ready() -> void:
	invecibility_timer = Timer.new()
	if on_hit_invecibility_time > 0:
		invecibility_timer.wait_time = on_hit_invecibility_time
		invecibility_timer.timeout.connect(_on_invencibility_time_timeout)
	add_child(invecibility_timer)

func damage(valor: int) -> void:
	if entity_life > 0 and not invincibility:
		var old_life := entity_life
		entity_life = max(0, entity_life - valor)
		if old_life > entity_life:
			damage_received.emit(old_life - entity_life)
		if on_hit_invecibility_time > 0:
			invencibility_frames(on_hit_invecibility_time)

	if entity_life == 0:
		death.emit()

func recover(heal: int) -> void:
	if entity_life < max_life or can_exceed_max:
		var old_life := entity_life
		if can_exceed_max:
			entity_life += heal
		else:
			entity_life = min(max_life, entity_life + heal)
		if entity_life > old_life:
			healing_received.emit(entity_life - old_life)

func invencibility_frames(invecibility_time: float) -> void:
	invecibility_timer.start(invecibility_time)
	invincibility = true

func _on_invencibility_time_timeout() -> void:
	invincibility = false
	invecibility_end.emit()
