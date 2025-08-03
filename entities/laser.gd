extends Area2D


func _ready() -> void:
	$Duration.timeout.connect(_on_duration_timeout)
	$Cooldown.timeout.connect(_on_cooldown_timeout)
	$Cooldown.start() 

func _on_cooldown_timeout():
	AudioManager.play_global("level.danger.electric")
	$Collision.disabled = false
	$Sprite.visible = true
	$Duration.start()


func _on_duration_timeout() -> void:
	$Collision.disabled = true
	$Sprite.visible = false
	$Cooldown.start()
