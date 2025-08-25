extends Resource

class_name EnemyAttack

@export_group("Attack")
@export var has_attack: bool
@export var attack_damage: float
@export_group("")

@export_group("Buff")
@export var has_buff: bool
@export var buff: float
@export_group("")

@export_group("Debuff")
@export var has_debuff: bool
@export var debuff: float
@export_group("")
