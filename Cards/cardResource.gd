extends Resource

class_name CardResource

@export var name: String
@export_multiline var description: String
@export var img: Texture2D
@export var img_size: Vector2
@export var sanity_cost: int

# ATTACK ----------------
@export var has_attack: bool
@export_group("Attack Info")
@export var attack_damage_value: float
@export var attack_target_type: float
@export_group("")

## DEFENSE ------------------
#@export var has_defense: bool
#@export_group("Defense Info")
#@export var defense_value: float
##@export var damage_target: int
#@export_group("")

# HEAL ----------------------
@export var has_heal: bool
@export_group("Heal Info")
@export var heal_value: float
@export_group("")

# BUFF -------------------------
@export var has_self_buff: bool
@export_group("Buff Info")

# DAMAGE BUFF
@export var has_damage_buff: bool
@export_subgroup("Damage Buff Info")
@export var damage_buff_value: float
@export_subgroup("")

# DEFENSE BUFF
@export var has_defense_buff: bool
@export_subgroup("Defense Buff Info")
@export var defense_buff_value: float
@export_subgroup("")
@export_group("")

# ENEMY DEBUFF ------------------------
@export var has_enemy_debuff: bool
@export_group("Enemy Debuff Info")

# ENEMY DAMAGE DEBUFF
@export var has_enemy_damage_debuff: bool
@export_subgroup("Damage Debuff Info")
@export var damage_enemy_debuff_value: float
@export_subgroup("")

# ENEMY DEFENSE DEBUFF
@export var has_enemy_defense_debuff: bool
@export_subgroup("Defense Debuff Info")
@export var enemy_defense_debuff_value: float
@export_subgroup("")

# ENEMY POISON APPLAY
@export var has_enemy_damage_poison: bool
@export_subgroup("Damage Poison Info")
@export var enemy_damage_poison_value: float
@export_subgroup("")
@export_group("")

# SELF DEBUFF ------------------------
@export var has_self_debuff: bool
@export_group("Self Debuff Info")

# SELF DAMAGE DEBUFF
@export var has_self_damage_debuff: bool
@export_subgroup("Damage Debuff Info")
@export var damage_self_debuff_value: float
@export_subgroup("")

# SELF DEFENSE DEBUFF
@export var has_self_defense_debuff: bool
@export_subgroup("Defense Debuff Info")
@export var self_defense_debuff_value: float
@export_subgroup("")
@export_group("")
