extends Resource

class_name EnemyResource

@export var enemy_name: String
@export_multiline var description: String
@export var animation: EnemyAnimationResource
@export var max_healt: float

@export var attack_list: Array[EnemyAttack] = []
