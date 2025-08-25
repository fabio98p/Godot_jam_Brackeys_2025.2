extends Node2D

@export var enemyResource: EnemyResource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var nameEnemy: Label = $Name
@onready var desc: Label = $Desc
@onready var healt: Label = $Healt
@onready var next_attack: Label = $NextAttack

var enemyDataHandler: EnemyDataHandler
func _ready() -> void:
	var enemy_data: EnemyResource = enemyResource.duplicate()
	enemyDataHandler = EnemyDataHandler.new(enemy_data)
	
	nameEnemy.text = "name: " + enemyDataHandler.enemy_name
	desc.text = "desc: " + enemyDataHandler.description
	healt.text = "max_healt: " + str(enemyDataHandler.max_healt)
	next_attack.text = "next_attack: " + str(enemyDataHandler.getNextAttack().attack_damage)
	
	sprite_2d.texture = enemyDataHandler.img
	
