extends Resource

class_name EnemyResource

@export var enemy_name: String
@export_multiline var description: String
@export var img: Texture
@export var img_size: Vector2
@export var max_healt: float

@export var attack_list: Array[EnemyAttack] = []
