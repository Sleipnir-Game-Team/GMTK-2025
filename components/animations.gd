extends AnimationPlayer

var next_anim = "RESET"
var post_animation_action_callable = null

var last_data = {}

func _ready():
	animation_finished.connect(_on_animation_finished)


func play_animation(animation, speed = 1, reset = true, forced = false):
	if !get_parent().locked or forced:
		last_data.speed = speed
		last_data.forced = forced
		var backwards = false
		if speed < 0:
			speed *= -1
			backwards = true
		var loop = get_animation(animation).loop_mode
		if (not loop) or (current_animation != animation):
			speed_scale = speed
			if reset:
				next_anim = animation
				play("RESET")
			else:
				if next_anim == animation:
					next_anim = "RESET"
				if !backwards:
					play(animation)
				else:
					print("backwards")
					play_backwards(animation)

func stop_animation(animation = ""):
	if animation == "" or animation == current_animation:
		play("RESET")
		speed_scale = 1

func lock():
	get_parent().locked = true

func unlock():
	get_parent().locked = false

func _on_animation_finished(anim_name):
	if next_anim != "RESET":
		play_animation(next_anim, last_data.speed, false, last_data.forced)
		next_anim = "RESET"

func post_animation_action():
	if post_animation_action_callable != null:
		post_animation_action_callable.call()
		post_animation_action_callable = null
