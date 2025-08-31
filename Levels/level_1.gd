extends Node2D
@onready var player: Node2D = $Player
var enemy: Node2D
var running_turn: bool = false
var enemy_is_dead: bool = false
@onready var background: Sprite2D = $background
@onready var bars: Node2D = $Bars
@onready var card_manager: Node2D = $CardManager
@onready var drop_zone: Node2D = $CardManager/DropZone

# Chose Reward
@onready var chose_card: Node2D = $ChoseCard
@onready var reward_1: Button = $ChoseCard/Reward1
@onready var reward_2: Button = $ChoseCard/Reward2
# button
@onready var skip_round: Button = $SkipRound

# Bookmarks
@onready var bookmarcs: Node2D = $Bookmarcs
@onready var Rest: Button = $Bookmarcs/Bookmark1
@onready var Next: Button = $Bookmarcs/Bookmark2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var Next_label: Label = $Bookmarcs/Label
@onready var Rest_label: Label = $Bookmarcs/Label2

@export var level_resource: LevelResource

# Icons for show buff
@onready var player_buff: TextureRect = $effects/PlayerBuffGrid/PlayerBuff
@onready var player_debuff: TextureRect = $effects/PlayerBuffGrid/PlayerDebuff
@onready var enemy_buff: TextureRect = $effects/EnemyBuffGrid/EnemyBuff
@onready var enemy_debuff: TextureRect = $effects/EnemyBuffGrid/EnemyDebuff

@onready var next_attack: TextureRect = $NextAttack

func _ready() -> void:
	enemy_is_dead = false
	GC.new_turn = true
	GC.new_turn_click = true
	GC.cards_drawn_this_turn=0
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
	bars.init_stats(player.max_health, 10, enemy.enemyDataHandler.max_healt, 10)
	bars.set_player_health(player.current_health)
	bars.set_enemy_health(enemy.enemyDataHandler.max_healt)
	bars.set_player_sanity(player.current_sanity)
	player.dead.connect(transition_dead)
	
	# enemy next attack
	next_attack.visible = true
	next_attack.updateNewtAttack(enemy.new_attack)
	
	# Setup Rewards
	chose_card.visible = false
	level_resource.reward1 = Pools.RewardPool[randi_range(0, Pools.RewardPool.size()-1)].duplicate()
	reward_1.icon = level_resource.reward1.img
	#reward_1.scale = level_resource.reward1.img_size
	level_resource.reward2 = Pools.RewardPool[randi_range(0, Pools.RewardPool.size()-1)].duplicate()
	reward_2.icon = level_resource.reward2.img
	#reward_1.scale = level_resource.reward1.img_size

func _process(delta: float) -> void:
	#print(player.attack_multiply, player.defense_multiply)
	if player.attack_multiply != 0 or player.defense_multiply != 0:
		#BUFF
		if player.attack_multiply > 0 or player.defense_multiply > 0:
			player_buff.visible = true
			#attack
			if player.attack_multiply > 0:
				player_buff.attackValue = "Attack Buff: " + str(player.attack_multiply * 25) + "%"
			else:
				player_buff.attackValue = ""
			#defense
			if player.defense_multiply > 0:
				player_buff.defenseValue = "Defense Buff: " + str(player.defense_multiply * 25) + "%"
			else:
				player_buff.defenseValue = ""
		else:
			player_buff.visible = false
		#DEBUFF
		if player.attack_multiply < 0 or player.defense_multiply < 0:
			player_debuff.visible = true
			#attack
			if player.attack_multiply < 0:
				player_debuff.attackValue = "Attack Debuff: " + str(player.attack_multiply * 25) + "%"
			else:
				player_debuff.attackValue = ""
			#defense
			if player.defense_multiply < 0:
				player_debuff.defenseValue = "Defense Debuff: " + str(player.defense_multiply * 25) + "%"
			else:
				player_debuff.defenseValue = ""
		else:
			player_debuff.visible = false
	else:
		player_debuff.visible = false
		player_buff.visible = false
	if enemy.attack_multiply != 0 or enemy.defense_multiply != 0:
		#BUFF
		if enemy.attack_multiply > 0 or enemy.defense_multiply > 0:
			enemy_buff.visible = true
			#attack
			if enemy.attack_multiply > 0:
				enemy_buff.attackValue = "Attack Buff: " + str(enemy.attack_multiply * 25) + "%"
			else:
				enemy_buff.attackValue = ""
			#defense
			if enemy.defense_multiply > 0:
				enemy_buff.defenseValue = "Defense Buff: " + str(enemy.defense_multiply * 25) + "%"
			else:
				enemy_buff.defenseValue = ""
		else:
			enemy_buff.visible = false
		#DEBUFF
		if enemy.attack_multiply < 0 or enemy.defense_multiply < 0:
			enemy_debuff.visible = true
			#attack
			if enemy.attack_multiply < 0:
				enemy_debuff.attackValue = "Attack Debuff: " + str(enemy.attack_multiply * 25) + "%"
			else:
				enemy_debuff.attackValue = ""
			#defense
			if enemy.defense_multiply < 0:
				enemy_debuff.defenseValue = "Defense Debuff: " + str(enemy.defense_multiply * 25) + "%"
			else:
				enemy_debuff.defenseValue = ""
		else:
			enemy_debuff.visible = false
	else:
		enemy_debuff.visible = false
		enemy_buff.visible = false
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
				await get_tree().create_timer(1.5).timeout
				enemy.enemy_dmg_taken(final_value)
				bars.set_enemy_health(enemy.current_health)
				bars.set_enemy_shield(enemy.shield)
			"heal_self":
				player.start_buff_animation()
				await get_tree().create_timer(1.5).timeout
				player.heal_self(value)
				bars.set_player_health(player.current_health)
			"apply_self_damage_buff":
				player.start_buff_animation()
				await get_tree().create_timer(1.5).timeout
				print("fkdhas",player.attack_multiply)
				player.attack_multiply += value
				print("fkdhas",player.attack_multiply)
				
			"apply_self_defense_buff":
				player.start_buff_animation()
				await get_tree().create_timer(1.5).timeout
				player.defense_multiply += value
			"apply_enemy_attack_debuff":
				player.start_buff_animation()
				await get_tree().create_timer(1.5).timeout
				enemy.attack_multiply += value
			"apply_enemy_defense_debuff":
				player.start_buff_animation()
				await get_tree().create_timer(1.5).timeout
				enemy.defense_multiply += value
			#"apply_enemy_poison":
				#player.defense_multiply = value
			"apply_self_damage_debuff":
				player.start_buff_animation()
				await get_tree().create_timer(1.5).timeout
				player.attack_multiply += value
			"apply_self_defense_debuff":
				player.start_buff_animation()
				await get_tree().create_timer(1.5).timeout
				player.defense_multiply += value
			"shield_self":
				player.start_buff_animation()
				await get_tree().create_timer(1.5).timeout
				player.shield += value
				bars.set_player_shield(player.shield)

func _on_skip_round_pressed() -> void:
	if !running_turn:
		drop_zone.get_node("Area2D/CollisionShape2D").disabled = true
		running_turn = true
		skip_round.modulate = Color(1, 1, 1, 0.5)
		next_attack.visible = false
		#apply enemy attack
		var enemyAttack:EnemyAttack = enemy.applay_next_attack()
		# Shield
		if enemyAttack.has_shield: 
			enemy.start_buff_animation()
			await get_tree().create_timer(1.5).timeout
			enemy.shield += enemyAttack.shield_value
			bars.set_enemy_shield(enemy.shield)
			
		# Heal
		if enemyAttack.has_heal:
			enemy.start_buff_animation()
			await get_tree().create_timer(1.5).timeout
			enemy.current_health += enemyAttack.heal_value
			bars.set_enemy_health(enemy.current_health)
		# Self Buff
		if enemyAttack.has_self_buff:
			enemy.start_buff_animation()
			await get_tree().create_timer(1.5).timeout
			if enemyAttack.has_self_attack_buff:
				player.attack_multiply += enemyAttack.self_attack_buff 
			if enemyAttack.has_self_defense_buff:
				player.defense_multiply += enemyAttack.self_defense_buff 
		
		# Player Debuff
		if enemyAttack.has_player_debuff: 
			enemy.start_buff_animation()
			await get_tree().create_timer(1.5).timeout
			if enemyAttack.has_player_attack_debuff:
				player.attack_multiply += enemyAttack.player_attack_debuff 
			if enemyAttack.has_player_defense_debuff:
				player.defense_multiply += enemyAttack.player_defense_debuff 
		
		# Attack must be the last
		if enemyAttack.has_attack: 
			var finalMoltiplicator = clamp(1 + (enemy.attack_multiply*0.25) - (player.defense_multiply*0.25),0,3)
			var enemy_attack_damage = enemyAttack.attack_damage * finalMoltiplicator
			enemy.start_charge_attack()
			await get_tree().create_timer(2.5).timeout
			player.dmg_taken(enemy_attack_damage)
			print("shiels",player.shield)
			bars.set_player_health(player.current_health)
			bars.set_player_shield(player.shield)
		
		running_turn = false
		skip_round.modulate = Color(1, 1, 1, 1)
		next_attack.visible = true
		next_attack.updateNewtAttack(enemy.new_attack)
	drop_zone.get_node("Area2D/CollisionShape2D").disabled = false
	GC.new_turn = true
	GC.new_turn_click = true
	GC.cards_drawn_this_turn=0
func _on_enemy_enemy_dead() -> void:
	if !enemy_is_dead:
		enemy_is_dead = true
		drop_zone.queue_free()
		skip_round.queue_free()
		next_attack.visible = false
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
	bookmarcs.visible=true
	if GC.numberOfFight == 3 or GC.numberOfFight == 8:
		Rest.visible = true
		Rest_label.visible= true
		Next.visible = false
		Next_label.visible = false
	else:
		Rest.visible = false
		Rest_label.visible= false
		Next.visible = true
		Next_label.visible = true

func _on_reward_2_pressed() -> void:
	GC.runDeck.append(level_resource.reward2)
	Utils.play_sfx(Pools.GetCocky[randi_range(0,Pools.GetCocky.size()-1)], "SFX")
	await get_tree().create_timer(0.5).timeout
	chose_card.visible = false
	bookmarcs.visible=true
	if GC.numberOfFight == 3 or GC.numberOfFight == 8:
		Rest.visible = true
		Rest_label.visible= true
		Next.visible = false
		Next_label.visible = false
	else:
		Rest.visible = false
		Rest_label.visible= false
		Next.visible = true
		Next_label.visible = true

func _on_bookmark_1_pressed() -> void:
	
	GC.player_actually_health = player.current_health + 5
	GC.player_actually_sanity = player.current_sanity + 5
	
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
	get_tree().change_scene_to_file("res://Levels/Falo.tscn")

func _on_bookmark_2_pressed() -> void:
	
	GC.player_actually_health = player.current_health + 5
	GC.player_actually_sanity = player.current_sanity + 5
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")



func transition_dead(reason) -> void:
	animation_player.play("Sanity_dead")
	var audioLoaded: AudioStreamMP3 = load(reason.audio)
#	effetto sinusoide
#	funzione ricorsiva andiamo a whillare audio in negativo del audiolevel
	GC.willingAudio(audioLoaded, 1)
	await get_tree().create_timer(7).timeout
	get_tree().change_scene_to_file(reason.scene)
