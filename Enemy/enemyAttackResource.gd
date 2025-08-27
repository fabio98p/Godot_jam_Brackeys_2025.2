extends Resource

class_name EnemyAttack

@export_group("Attack")
@export var has_attack: bool
@export var attack_damage: float
@export_group("")

@export_group("Shield")
@export var has_shield: bool
@export var shield_value: float
@export_group("")

@export_group("Heal")
@export var has_heal: bool
@export var heal_value: float
@export_group("")

@export_group("Self Buff")
@export var has_self_buff: bool
@export var has_self_attack_buff: bool
@export var self_attack_buff: float
@export var has_self_defense_buff: bool
@export var self_defense_buff: float
@export_group("")

@export_group("Player Debuff")
@export var has_player_debuff: bool
@export var has_player_attack_debuff: bool
@export var player_attack_debuff: float
@export var has_player_defense_debuff: bool
@export var player_defense_debuff: float
@export_group("")
