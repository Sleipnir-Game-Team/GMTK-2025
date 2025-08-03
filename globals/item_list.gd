extends Node

var ativo := [
	{
		"name": "Air Hold",
		"script": preload("res://item/ativo/air_hold.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup1_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup1_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup1_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"Hold yourself in the air until you move"
	},{
		"name": "Double Jump",
		"script": preload("res://item/ativo/double_jump.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup1_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup1_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup1_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"After using this you can do one double jump"
	},{
		"name": "Dash",
		"script": preload("res://item/ativo/extra_dash.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup1_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup1_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup1_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"You can dash one time wherever you are"},
]

var consumivel := [{
		"name": "Invulnerability",
		"script": preload("res://item/consumivel/invulnerable.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup2_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup2_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup2_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"Obtain temporary invulnerability"},{
		"name": "Dash",
		"script": preload("res://item/consumivel/double_life.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup2_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup2_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup2_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"You can dash one time wherever you are"}]

var permanente := [{
		"name": "Vida Extra",
		"script": preload("res://item/permanente/health_cd.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup3_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup3_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup3_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"Receba vida permanente"},{
		"name": "Invencivel",
		"script": preload("res://item/permanente/invicible_time.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup3_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup3_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup3_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"Fique mais tempo invencivel ao tomar dano"},{
		"name": "Velocidade",
		"script": preload("res://item/permanente/player_speed.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup3_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup3_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup3_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"Receba velocidade permanente"},{
		"name": "Tempo",
		"script": preload("res://item/permanente/level_time.gd"),
		"images":{
			"hover":preload("res://assets/Art_assets/Powerup3_hover.png"),
			"normal":preload("res://assets/Art_assets/Powerup3_normal.png"),
			"pressed":preload("res://assets/Art_assets/Powerup3_pressed.png"),
			"disabled":preload("res://assets/Art_assets/Powerup_disabled.png")
		},
		"description":"Aumente o limite de tempo um pouco"}]
