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
				var finalMoltiplicator = clamp(1 + (player.attack_multiply*0.25) - (enemy.defense_multiply*0.25),0,3)
				var final_value= value * finalMoltiplicator
				enemy.enemy_dmg_taken(final_value)
			"heal_self":
				player.heal_self(value)
			"apply_self_damage_buff":
				player.attack_multiply += value
			"apply_self_defense_buff":
				player.defense_multiply += value
			"apply_enemy_attack_debuff":
				enemy.attack_multiply += value
			"apply_enemy_defense_debuff":
				enemy.defense_multiply += value
			#"apply_enemy_poison":
				#player.defense_multiply = value
			"apply_self_damage_debuff":
				player.attack_multiply += value
			"apply_self_defense_debuff":
				player.defense_multiply += value
			"shield_self":
				player.shield += value

func _on_skip_round_pressed() -> void:
	#apply enemy attack
	var enemyAttack:EnemyAttack = enemy.applay_next_attack()
	# Shield
	if enemyAttack.has_shield: 
		enemy.shield += enemyAttack.shield_value
		
	# Heal
	if enemyAttack.has_heal: 
		enemy.heal += enemyAttack.heal_value
		
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
	
	# Attack must be the last
	if enemyAttack.has_attack: 
		var finalMoltiplicator = clamp(1 + (enemy.attack_multiply*0.25) - (player.defense_multiply*0.25),0,3)
		var enemy_attack_damage = enemyAttack.attack_damage * finalMoltiplicator
		player.dmg_taken(enemy_attack_damage)
	
