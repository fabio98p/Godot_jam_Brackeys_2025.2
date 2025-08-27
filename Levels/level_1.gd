extends Node2D
@onready var player: Node2D = $Player
@onready var enemy: Node2D = $Enemy
@export var level_resource: LevelResource
@onready var background: Sprite2D = $background


func _ready() -> void:
	#var stileBox: StyleBoxTexture = StyleBoxTexture.new()
	#stileBox.texture = level_resource.background
	var decompressedBG= level_resource.background.get_image()
	background.texture = ImageTexture.create_from_image( decompressedBG) as Texture2D

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
				player.attack_multiply += value
			"apply_self_defense_buff":
				player.defense_multiply += value
			"apply_enemy_attack_debuff":
				enemy.defense_multiply -= value
			"apply_enemy_defense_debuff":
				enemy.defense_multiply -= value
			#"apply_enemy_poison":
				#player.defense_multiply = value
			"apply_self_damage_debuff":
				player.attack_multiply = -value
			"apply_self_defense_debuff":
				player.defense_multiply = -value
			


func _on_skip_round_pressed() -> void:
	#apply enemy attack
	var enemyAttack:EnemyAttack = enemy.applay_next_attack()
	
	# Attack
	if enemyAttack.has_attack: 
		var enemy_attack_damage = enemyAttack.attack_damage * player.attack_multiply
		enemy_attack_damage = enemy_attack_damage * enemy.defense_multiply
		player.dmg_taken(enemy_attack_damage)
	
	# Self Buff
	if enemyAttack.has_self_buff:
		if enemyAttack.has_self_attack_buff:
			player.attack_multiply += enemyAttack.self_attack_buff 
		if enemyAttack.has_self_defense_buff:
			player.defense_multiply += enemyAttack.self_defense_buff 
	
	# Player Debuff
	if enemyAttack.has_player_debuff: 
		if enemyAttack.has_player_attack_debuff:
			player.attack_multiply += enemyAttack.player_attack_debuff 
		if enemyAttack.has_player_defense_debuff:
			player.defense_multiply += enemyAttack.player_defense_debuff 
