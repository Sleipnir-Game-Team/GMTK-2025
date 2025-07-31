extends CharacterBody2D

@export_group("Jump", "jump")

## Altura do pulo em termos da altura do personagem. Por exemplo: [br]
## • [code]2.0[/code]  - Pula duas vezes sua altura 
@export var jump_height_factor: float = 2.0

## Tempo em segundos para chegar na altura máxima do pulo.
@export var jump_time_to_peak: float = 0.4

## Tempo em segundos para voltar ao solo depois de chegar na altura máxima.
@export var jump_time_to_descent: float = 0.35

## Multiplicador da gravidade aplicado quando o pulo é cortado ao meio.
## Aplicado apenas quando o botão de pular é solto antes do pico. 
@export var jump_cut_multiplier: float = 2.0

@export_group("Movement", "movement")
@export var movement_walking_speed: float = 200.0
@export_range(1, 10, .2) var movement_sprint_modifier: float = 2.0
@export_range(0.1, 1, .05) var movement_crouch_modifier: float = 0.8

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

@onready var gravity_rise: float = _calculate_gravity_rise(jump_height_factor, jump_time_to_peak)
@onready var gravity_fall: float = _calculate_gravity_fall(jump_height_factor, jump_time_to_descent)
@onready var jump_speed: float = _calculate_jump_speed(gravity_rise, jump_time_to_peak)

var crouching: bool = false

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_crouch"):
		crouching = true
	elif event.is_action_released("player_crouch"):
		crouching = false

func _physics_process(delta: float) -> void:
	var g := gravity_rise
	if _falling():
		# Se está caindo, gravidade padrão de queda
		g = gravity_fall
	elif not Input.is_action_pressed("player_jump"):
		# Se está subindo e soltou o botão de pulo, aumenta a gravidade para cair mais rápido
		g *= jump_cut_multiplier
	
	velocity.y += g * delta
	
	velocity.x = 0.0
	if Input.is_action_pressed("player_left"):
		velocity.x = -movement_walking_speed
	if Input.is_action_pressed("player_right"):
		velocity.x = movement_walking_speed
	
	if crouching:
		velocity.x *= movement_crouch_modifier
		 
	elif Input.is_action_pressed("player_sprint"):
		velocity.x *= movement_sprint_modifier
	
	
	if is_on_floor() and Input.is_action_just_pressed("player_jump"):
		velocity.y = jump_speed
	
	move_and_slide()


func _falling() -> bool:
	return velocity.y > 0

func _get_character_height_world() -> float:
	var local_height := collision_shape_2d.shape.get_rect().size.y
	return local_height * collision_shape_2d.global_scale.y

func _target_jump_height_px(height_factor: float) -> float:
	return height_factor * _get_character_height_world()

func _calculate_gravity_rise(height_factor: float, time_to_peak: float) -> float:
	var h := _target_jump_height_px(height_factor)
	return 2.0 * h / (time_to_peak * time_to_peak)

func _calculate_gravity_fall(height_factor: float, time_to_descent: float) -> float:
	var h := _target_jump_height_px(height_factor)
	return 2.0 * h / (time_to_descent * time_to_descent)

func _calculate_jump_speed(gravity_rise: float, time_to_peak: float) -> float:
	return -gravity_rise * time_to_peak
