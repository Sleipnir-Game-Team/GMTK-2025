extends Area2D


func _on_body_entered(body):
	$Warmup.start()


func _on_duration_timeout():
	$ActivatedArea/Collision.disabled = true
	$Collision.disabled = true
	$Cooldown.start()


func _on_cooldown_timeout():
	$Collision.disabled = false


func _on_warmup_timeout():
	$ActivatedArea/Collision.disabled = false
	$Duration.start()
