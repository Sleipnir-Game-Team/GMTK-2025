extends Area2D

func _on_cooldown_timeout():
	AudioManager.play_global("level.danger.electric")
	$Collision.disabled = false
	$Duration.start()


func _on_duration_timeout():
	$Collision.disabled = true
	$Cooldown.start()
