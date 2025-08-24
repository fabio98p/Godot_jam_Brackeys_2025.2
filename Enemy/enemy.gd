extends Node2D

@export var enemyResource: EnemyResource
var enemy_name: String
var img: Texture
var healt: float
var attack: float

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var enemy_data: EnemyResource = enemyResource.duplicate()
	enemy_name = enemy_data.enemy_name
	sprite_2d.texture = enemy_data.img
	healt = enemy_data.max_healt
	attack = enemy_data.attack_damage

	print(healt)
	print(attack)
