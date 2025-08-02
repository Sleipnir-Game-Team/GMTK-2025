extends CharacterBody2D

@export_group("Jump", "jump")
#region
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

## Tempo em segundos em que o comando de pulo é salvo caso o jogador não esteja no chão
@export var jump_buffer_time: float = 0.2

## Velocidade horizontal de saltos iniciados mid-dash.
@export var jump_dash_boost: float = 2000.0

## Tempo extra em segundos para saltar após sair de uma plataforma.
@export var jump_coyote_time: float = 0.2

## Tempo extra em segundos para dar o comando de boost após um dash
@export var jump_boost_grace_period: float = 0.2


## Tempo atual no buffer de salto.[br]
## Se está no chão e esse valor é acima de 0, pular.
var jump_buffer: float = 0

## Tempo atual no buffer de jump boost.[br]
## Se o dash já acabou, tem esse tempo extra para dar o boost.
var jump_boost_buffer: float = 0

## Se o input de pulo atual foi iniciado num dash.
var jump_boosted: bool = false

## Contador de tempo de coyote time.
var jump_coyote_counter: float = 0
#endregion

@export_group("Movement", "movement")
#region
## Velocidade horizontal de movimento em pixels/seg
@export var movement_walking_speed: float = 200.0

## Multiplicador da velocidade horizontal enquanto em sprint
@export_range(1, 10, .2) var movement_sprint_modifier: float = 2.0

## Multiplicador da velocidade horizontal enquanto agachado
@export_range(0.1, 1, .05) var movement_crouch_modifier: float = 0.8
#endregion

@export_subgroup("Dash", "dash")
#region
## Força do dash horizontal em pixels/seg
@export var dash_speed: float = 2000.0

## Duração do dash em segundos
@export var dash_duration: float = 0.15

var dash_time_left: float = 0.0
var facing: int = 1
#endregion

@export_group("Knockback", "knockback")
#region
## Duração total em segundos do knockback.[br]
## Metade desse tempo é subindo, a segunda metade caindo
@export var knockback_duration: float = 0.15

## Altura do knockback em termos da altura do personagem. Por exemplo: [br]
## • [code]2.0[/code]  - Sobe duas vezes sua altura 
@export var knockback_height_factor: float = 1.5

## Distância do knockback em termos da largura do personagem. Por exemplo: [br]
## • [code]2.0[/code]  - É empurrado duas vezes sua largura para trás
@export var knockback_width_factor: float = 2
var knockback_time: float = 0
#endregion

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D  

@onready var gravity_rise: float = _calculate_gravity_rise(jump_height_factor, jump_time_to_peak)
@onready var gravity_fall: float = _calculate_gravity_fall(jump_height_factor, jump_time_to_descent)
@onready var jump_speed: float = _calculate_jump_speed(gravity_rise, jump_time_to_peak)

@onready var gravity_knockback: float = _calculate_gravity_knockback(knockback_height_factor, knockback_duration)
@onready var knockback_horizontal_speed: float = _calculate_knockback_horizontal_speed(knockback_width_factor, knockback_duration)
@onready var knockback_speed: Vector2 = _calculate_knockback_speed(gravity_knockback, knockback_duration)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var life: Life = $Life
@onready var signalizer: Node = $Signalizer

var knocked: bool = false
var crouching: bool = false:
	set(_crouching):
		crouching = _crouching
		if crouching:
			animation_player.play("player/crouch")
		else:
			animation_player.play_backwards("player/crouch")

func _ready() -> void:
	signalizer.damage_received.connect(_on_signalizer_damage_received)

func _unhandled_key_input(event: InputEvent) -> void:
	# Evitar dar o crouch quando já está em sprint
	if event.is_action_pressed("player_crouch"):
		crouching = true
	elif event.is_action_released("player_crouch"):
		crouching = false

func _physics_process(delta: float) -> void:
	if knockback_time > 0:
		knockback_time -= delta
		if not knocked:
			knockback()
		else:
			velocity.y += gravity_knockback * delta
		move_and_slide()
		return
	else:
		knocked = false
	
	var g := gravity_rise
	if _falling():
		# Se está caindo, gravidade padrão de queda
		g = gravity_fall
	elif not Input.is_action_pressed("player_jump"):
		# Se está subindo e soltou o botão de pulo, aumenta a gravidade para cair mais rápido
		g *= jump_cut_multiplier
	
	velocity.y += g * delta
	
	if jump_boosted and is_on_floor():
		jump_boosted = false
	
	# Captura do comando de pulo
	if Input.is_action_just_pressed("player_jump"):
		if _can_jump_boost():
			# Pulo iniciado durante o dash
			boosted_jump()
		else:
			jump_buffer = jump_buffer_time
	
	# Início de dash: sprint + crouch, precisa estar no chão
	if not _dashing() \
		and is_on_floor() \
		and Input.is_action_pressed("player_sprint") \
		and Input.is_action_just_pressed("player_crouch"):
		dash()
	
	if _dashing():
		dash_time_left -= delta
		# Velocidade constante do dash.
		velocity.x = facing * dash_speed
	
	# Movimento horizontal (fora do dash)
	if not _dashing():
		# Direção do Input do usuário
		var input_axis := Input.get_axis("player_left", "player_right")
		
		var target_speed := movement_walking_speed
		
		if jump_boosted and input_axis == facing:
			# Se está em um boosted jump e segurando o input na direção do salto, mantém a velocidade
			target_speed = jump_dash_boost
		else:
			jump_boosted = false
			facing = int(input_axis)
			
			if crouching:
				# Agachado ignora o sprint
				target_speed *= movement_crouch_modifier
			elif Input.is_action_pressed("player_sprint"):
				target_speed *= movement_sprint_modifier
		
		velocity.x = input_axis * target_speed
	
	# Pulo normal
	if _can_jump():
		jump()
	else:
		jump_buffer -= delta
		jump_boost_buffer -= delta
	
	if is_on_floor():
		jump_coyote_counter = jump_coyote_time
	else:
		jump_coyote_counter -= delta
	
	move_and_slide()

func jump() -> void:
	jump_buffer = 0
	jump_coyote_counter = 0
	velocity.y = jump_speed

func boosted_jump() -> void:
	jump_boosted = true
	jump_boost_buffer = 0
	dash_time_left = 0
	velocity.x = facing * jump_dash_boost
	jump()

func dash() -> void:
	dash_time_left = dash_duration
	jump_boost_buffer = dash_duration + jump_boost_grace_period

func knockback() -> void:
	knocked = true
	dash_time_left = 0
	velocity = knockback_speed

func _dashing() -> bool:
	return dash_time_left > 0

func _can_jump() -> bool:
	return _jump_buffered() and ((is_on_floor() and not _dashing()) or jump_coyote_counter > 0)

func _can_jump_boost() -> bool:
	return jump_boost_buffer > 0

func _jump_buffered() -> bool:
	return jump_buffer > 0

func _falling() -> bool:
	return velocity.y > 0

func _get_character_height_world() -> float:
	var local_height := collision_shape_2d.shape.get_rect().size.y
	return local_height * collision_shape_2d.global_scale.y

func _get_character_width_world() -> float:
	var local_width := collision_shape_2d.shape.get_rect().size.x
	return local_width * collision_shape_2d.global_scale.x

#region JUMP Auxiliary Functions
func _target_jump_height_px(height_factor: float) -> float:
	return height_factor * _get_character_height_world()

func _calculate_gravity_rise(height_factor: float, time_to_peak: float) -> float:
	var h := _target_jump_height_px(height_factor)
	return 2.0 * h / pow(time_to_peak, 2)

func _calculate_gravity_fall(height_factor: float, time_to_descent: float) -> float:
	var h := _target_jump_height_px(height_factor)
	return 2.0 * h / (time_to_descent * time_to_descent)

func _calculate_jump_speed(gravity: float, time_to_peak: float) -> float:
	return -gravity * time_to_peak
#endregion

#region KNOCKBACK Auxiliary Functions
func _target_knockback_distance(width_factor: float) -> float:
	return width_factor * _get_character_width_world()

func _calculate_knockback_horizontal_speed(width_factor: float, duration: float) -> float:
	var w := _target_knockback_distance(width_factor)
	return w / duration

func _calculate_gravity_knockback(height_factor: float, duration: float) -> float:
	var h := _target_jump_height_px(height_factor)
	var time_to_peak := duration / 2
	return 2.0 * h / pow(time_to_peak, 2)

func _calculate_knockback_speed(gravity: float, duration: float) -> Vector2:
	var time_to_peak := duration / 2
	return Vector2(knockback_horizontal_speed, -gravity * time_to_peak)
#endregion

func _on_signalizer_damage_received(dealer: Area2D, _ammount: int) -> void:
	var dir := signi(int((global_position - dealer.global_position).x))
	knockback_speed.x = knockback_horizontal_speed * dir
	knockback_time = knockback_duration
