extends Area2D

var antisafadeza = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$Duration.timeout.connect(_on_duration_timeout)
	$Warmup.timeout.connect(_on_warmup_timeout)
	$Cooldown.timeout.connect(_on_cooldown_timeout)

func _process(delta):
	$Sprite2D.visible = !$ActivatedArea/Collision.disabled
	if !$Warmup.is_stopped():
		$Incinerator.get_material().set_shader_parameter("unredness", ($Warmup.time_left/$Warmup.wait_time))
	elif !$Duration.is_stopped() or !$Cooldown.is_stopped():
		$Incinerator.get_material().set_shader_parameter("unredness", 0)
	else:
		$Incinerator.get_material().set_shader_parameter("unredness", 1)

func _on_body_entered(body):
	if !antisafadeza:
		antisafadeza = true
		$Collision.disabled = true
		$Warmup.start()

func _on_duration_timeout() -> void:
	$ActivatedArea/Collision.disabled = true
	$Cooldown.start()


func _on_cooldown_timeout():
	antisafadeza = false
	$Collision.disabled = false


func _on_warmup_timeout() -> void:
	$flame.play()
	$ActivatedArea/Collision.disabled = false
	$Duration.start()
