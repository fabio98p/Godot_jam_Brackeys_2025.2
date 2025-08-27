extends Node2D

@export var enemyResource: EnemyResource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var nameEnemy: Label = $Name
@onready var desc: Label = $Desc
@onready var health: Label = $Healt
@onready var next_attack: Label = $NextAttack
@onready var attack_multi: Label = $AttackMulti
@onready var defense_multi: Label = $DefenseMulti
@onready var shieldLabel: Label = $Shield

var shield: int = 0
# attack and defense have max of 3 multiply,
# every multiply is a x0.25 of damage for a max of *1.75 or 
var attack_multiply: float = 0:
	set(value):
		attack_multiply = clamp(attack_multiply + value,-3,3)
		attack_multi.text =  "attack multy: " + str(attack_multiply)
var defense_multiply: float = 0:
	set(value):
		defense_multiply = clamp(defense_multiply + value,-3,3)
		defense_multi.text = "defense multy: " + str(defense_multiply)
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
	attack_multi.text =  "attack multy: " + str(attack_multiply)
	defense_multi.text = "defense multy: " + str(defense_multiply)
	shieldLabel.text = "Shield: " + str(shield)
	sprite_2d.texture = enemyDataHandler.img
	
#func dmg_taken(value):
	#print("enemy current",enemyDataHandler.current_healt)
	#enemyDataHandler.current_healt = enemyDataHandler.current_healt - value 
	#health.text = "max_healt: " + str(enemyDataHandler.current_healt)
	#if enemyDataHandler.current_healt <= 0:
		#health.text = "max_healt: " +  "dead health"

func enemy_dmg_taken(value: int) -> void:
	print("enemy current", enemyDataHandler.current_healt)

	var damage_after_shield = value
	
	if shield >= value:
		shield -= value
		damage_after_shield = 0
	else:
		damage_after_shield = value - shield
		shield = 0
	shieldLabel.text = "Shield: " + str(shield)
	enemyDataHandler.current_healt -= damage_after_shield
	
	if enemyDataHandler.current_healt > 0:
		health.text = "max_healt: " + str(enemyDataHandler.current_healt)
	else:
		health.text = "max_healt: dead health"



func applay_next_attack():
	var old_next_attack : EnemyAttack = new_attack
	new_attack = enemyDataHandler.getNextAttack()
	next_attack.text = "next_attack: " + str(new_attack.attack_damage)
	return old_next_attack
