extends Node
class_name EnemyDataHandler

var enemy_name: String:
	get:
		return enemy_name
var description: String:
	get:
		return description
var animation: EnemyAnimationResource:
	get:
		return animation
var max_healt: int:
	get:
		return max_healt
var current_healt: int:
	get:
		return current_healt
var attackList: Array[EnemyAttack]

func _init(enemyResource: EnemyResource) -> void:
	enemy_name = enemyResource.enemy_name
	description = enemyResource.description
	animation = enemyResource.animation
	max_healt = enemyResource.max_healt
	current_healt = max_healt
	attackList = enemyResource.attack_list

func getNextAttack():
	return 	attackList[randi_range(0, attackList.size() - 1)]
