extends Area2D

func _ready() -> void:
	%lighting.play()
	$Duration.timeout.connect(_on_duration_timeout)
	$Cooldown.timeout.connect(_on_cooldown_timeout)
	$Cooldown.start() 

func _on_cooldown_timeout():
	%lighting.set("parameters/switch_to_clip",2)
	$Collision.disabled = false
	$Sprite.visible = true
	$Duration.start()

func _on_duration_timeout() -> void:
	%lighting.set("parameters/switch_to_clip",1)
	$Collision.disabled = true
	$Sprite.visible = false
	$Cooldown.start()
