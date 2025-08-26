extends Node2D

@export var enemyResource: EnemyResource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var nameEnemy: Label = $Name
@onready var desc: Label = $Desc
@onready var health: Label = $Healt
@onready var next_attack: Label = $NextAttack
var attack_multiply: float = 1.0
var defense_multiply: float = 1.0
var current_health: float

var new_attack: EnemyAttack

var enemyDataHandler: EnemyDataHandler
func _ready() -> void:
	var enemy_data: EnemyResource = enemyResource.duplicate()
	enemyDataHandler = EnemyDataHandler.new(enemy_data)
	
	nameEnemy.text = "name: " + enemyDataHandler.enemy_name
	desc.text = "desc: " + enemyDataHandler.description
	health.text = "max_healt: " + str(enemyDataHandler.max_healt)
	new_attack = enemyDataHandler.getNextAttack()
	next_attack.text = "next_attack: " + str(new_attack.attack_damage)
	
	sprite_2d.texture = enemyDataHandler.img
	
func dmg_taken(value):
	print("enemy current",enemyDataHandler.current_healt)
	enemyDataHandler.current_healt = enemyDataHandler.current_healt - value 
	health.text = "max_healt: " + str(enemyDataHandler.current_healt)
	if enemyDataHandler.current_healt <= 0:
		health.text = "max_healt: " +  "dead health"

func applay_next_attack():
	var old_next_attack : EnemyAttack = new_attack
	new_attack = enemyDataHandler.getNextAttack()
	next_attack.text = "next_attack: " + str(new_attack.attack_damage)
	return old_next_attack
