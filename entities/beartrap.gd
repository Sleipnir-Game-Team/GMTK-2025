extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D) -> void:
	$Warmup.start()


func _on_duration_timeout() -> void:
	$ActivatedArea/Collision.disabled = true
	$Collision.disabled = true
	$Cooldown.start()


func _on_cooldown_timeout() -> void:
	$Collision.disabled = false


func _on_warmup_timeout() -> void:
	AudioManager.play_global("level.danger.flamethrower")
	$ActivatedArea/Collision.disabled = false
	$Duration.start()
