extends Resource

class_name CardResource

#@export_group("Generic Info")
@export var name: String
@export_multiline var description: String
@export var img: Texture
@export var img_size: Vector2
@export var sanity_cost: int


@export var has_attack: bool
@export_group("damage Info")
@export var damage_value: float
@export var attack_target_type: float


@export var has_defense: bool
@export_group("Defense Info")
@export var defense_value: float
#@export var damage_target: int


@export var has_heal: bool
@export_group("Heal Info")
@export var heal_value: float
#@export var damage_target: int

@export var has_buff: bool
@export_group("Damage Buff")
@export var has_damage_buff: bool
@export_subgroup("Damage Buff Info")
@export var damage_buff_value: float
