extends Node2D
@onready var player: Node2D = $Player
var enemy: Node2D
@onready var background: Sprite2D = $background
@onready var bars: Node2D = $Bars

# Chose Reward
@onready var chose_card: Node2D = $ChoseCard
@onready var reward_1: Button = $ChoseCard/Reward1
@onready var reward_2: Button = $ChoseCard/Reward2

# Bookmarks
@onready var bookmarcs: Node2D = $Bookmarcs
@onready var bookmark_1: Button = $Bookmarcs/Bookmark1
@onready var bookmark_2: Button = $Bookmarcs/Bookmark2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var level_resource: LevelResource

func _ready() -> void:

#	resetta il deck quando si inizia un nuovo livello
	#GC.resetDeck()
#	gestione dello sfondo skjdbgviksdbvskjdbgviksdbvskjdbgviksdbv
	var decompressedBG= level_resource.background.get_image()
	background.texture = ImageTexture.create_from_image( decompressedBG) as Texture2D
	# Setup Enemy
	var enemyResource: EnemyResource = GC.pickenemy()
	var enemyInstance = preload("res://Enemy/enemy.tscn").instantiate()
	enemyInstance.connect("enemy_dead", Callable(self, "_on_enemy_enemy_dead"))
	enemyInstance.enemyResource = enemyResource
	enemy = enemyInstance
	add_child(enemyInstance)
#	SETUP HUD BARS
	#	player_max_h: float, player_max_s: float, enemy_max_h: float, enemy_max_s: float
	bars.init_stats(player.current_health, 10, enemy.enemyDataHandler.max_healt, 10)
	bars.set_player_health(player.current_health)
	bars.set_enemy_health(enemy.enemyDataHandler.max_healt)
	bars.set_player_sanity(player.current_sanity)
	player.dead.connect(transition_dead)
	
	
	# Setup Rewards
	chose_card.visible = false
	reward_1.icon = level_resource.reward1.img
	#reward_1.scale = level_resource.reward1.img_size
	reward_2.icon = level_resource.reward2.img
	#reward_1.scale = level_resource.reward1.img_size
	
func applay_card_effect(cadsEffect):
	print(cadsEffect)
	for key in cadsEffect.keys():
		var value = cadsEffect[key]

		match key:
			"sanity_cost":
				player.sanity_taken(value)
				bars.set_player_sanity(player.current_sanity)
			"attack_enemy":
				var finalMoltiplicator = clamp(1 + (player.attack_multiply*0.25) - (enemy.defense_multiply*0.25),0,3)
				var final_value= value * finalMoltiplicator
				enemy.enemy_dmg_taken(final_value)
				bars.set_enemy_health(enemy.current_health)
				bars.set_enemy_shield(enemy.shield)
			"heal_self":
				player.heal_self(value)
				bars.set_player_health(player.current_health)
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
				bars.set_player_shield(player.shield)

func _on_skip_round_pressed() -> void:
	#apply enemy attack
	var enemyAttack:EnemyAttack = enemy.applay_next_attack()
	# Shield
	if enemyAttack.has_shield: 
		enemy.shield += enemyAttack.shield_value
		bars.set_enemy_shield(enemy.shield)
		
	# Heal
	if enemyAttack.has_heal:
		enemy.current_health += enemyAttack.heal_value
		bars.set_enemy_health(enemy.current_health)
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
		print("shiels",player.shield)
		bars.set_player_health(player.current_health)
		bars.set_player_shield(player.shield)
func _on_enemy_enemy_dead() -> void:
	if GC.numberOfFight == 10:
		await get_tree().create_timer(1).timeout
#		TODO mettere animazioni zoom
		if player.current_sanity == 1:
			get_tree().change_scene_to_file("res://Levels/Ending/Parents.tscn")
		if player.current_sanity > 1:
			get_tree().change_scene_to_file("res://Levels/Ending/Good.tscn")
	else:
		chose_card.visible = true
	
func _on_reward_1_pressed() -> void:
	GC.runDeck.append(level_resource.reward1)
	Utils.play_sfx(Pools.GetCocky[randi_range(0,Pools.GetCocky.size()-1)], "SFX")
	await get_tree().create_timer(0.5).timeout
	chose_card.visible = false
	bookmarcs.visible = true

func _on_reward_2_pressed() -> void:
	GC.runDeck.append(level_resource.reward2)
	Utils.play_sfx(Pools.GetCocky[randi_range(0,Pools.GetCocky.size()-1)], "SFX")
	await get_tree().create_timer(0.5).timeout
	chose_card.visible = false
	bookmarcs.visible = true

func _on_bookmark_1_pressed() -> void:
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
	if GC.numberOfFight == 3 or GC.numberOfFight == 8:
		get_tree().change_scene_to_file("res://Levels/Falo.tscn")
	else:
		get_tree().change_scene_to_file("res://Levels/level_1.tscn")

func _on_bookmark_2_pressed() -> void:
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
	if GC.numberOfFight == 3 or GC.numberOfFight == 8:
		get_tree().change_scene_to_file("res://Levels/Falo.tscn")
	else:
		get_tree().change_scene_to_file("res://Levels/level_1.tscn")



func transition_dead(reason) -> void:
	animation_player.play("Sanity_dead")
	var audioLoaded: AudioStreamMP3 = load(reason.audio)
#	effetto sinusoide
#	funzione ricorsiva andiamo a whillare audio in negativo del audiolevel
	GC.willingAudio(audioLoaded, 1)
	await get_tree().create_timer(7).timeout
	get_tree().change_scene_to_file(reason.scene)
