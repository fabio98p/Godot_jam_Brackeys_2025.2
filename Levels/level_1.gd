extends Node2D
@onready var player: Node2D = $Player
@onready var enemy: Node2D = $Enemy
@onready var background: Panel = $Backgorund
@export var level_resource: LevelResource


func _ready() -> void:
	var stileBox: StyleBoxTexture = StyleBoxTexture.new()
	stileBox.texture = level_resource.background
	background.add_theme_stylebox_override("panel", stileBox) 

func applay_card_effect(cadsEffect):
	print(cadsEffect)
	for key in cadsEffect.keys():
		var value = cadsEffect[key]

		match key:
			"sanity_cost":
				player.sanity_taken(value)
			"attack_enemy":
				var final_value= value * player.attack_multiply
				final_value = final_value * enemy.defense_multiply
				enemy.dmg_taken(final_value)
			"heal_self":
				player.heal_self(value)
			"apply_self_damage_buff":
				player.attack_multiply = value
			"apply_self_defense_buff":
				player.defense_multiply = value
			"apply_enemy_attack_debuff":
				enemy.defense_multiply = value
			"apply_enemy_defense_debuff":
				enemy.defense_multiply = value
			#"apply_enemy_poison":
				#player.defense_multiply = value
			"apply_self_damage_debuff":
				player.attack_multiply = value
			"apply_self_defense_debuff":
				player.defense_multiply = value
			
