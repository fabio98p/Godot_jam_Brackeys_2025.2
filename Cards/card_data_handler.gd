extends Node
class_name CardDataHandler

# Generic info
var cardName: String:
	get:
		return cardName
var description: String:
	get:
		return description
var img: Texture:
	get:
		return img
var img_size: Vector2:
	get:
		return img_size
var sanity_cost: int:
	get:
		return sanity_cost

# ATTACK ----------------
var has_attack: bool
var attack_damage_value: float
var attack_target_type: float

# HEAL ----------------------
var has_heal: bool
var heal_value: float

# BUFF -------------------------
var has_self_buff: bool

var has_damage_buff: bool
var damage_buff_value: float

var has_defense_buff: bool
var defense_buff_value: float

# ENEMY DEBUFF ------------------------
var has_enemy_debuff: bool

var has_enemy_attack_debuff: bool
var enemy_attack_debuff_value: float

var has_enemy_defense_debuff: bool
var enemy_defense_debuff_value: float

var has_enemy_damage_poison: bool
var enemy_damage_poison_value: float

# SELF DEBUFF ------------------------
var has_self_debuff: bool

var has_self_damage_debuff: bool
var damage_self_debuff_value: float

var has_self_defense_debuff: bool
var self_defense_debuff_value: float

var actionDictionary: Dictionary[String, float] = {}

var card_istance
func _init(cardResource: CardResource, card) -> void:
	card_istance = card
	
	cardName = cardResource.name
	description = cardResource.description
	img = cardResource.img
	img_size = cardResource.img_size
	sanity_cost = cardResource.sanity_cost
	actionDictionary["sanity_cost"] = sanity_cost
	
	#Attack
	has_attack = cardResource.has_attack
	attack_damage_value = cardResource.attack_damage_value
	attack_target_type = cardResource.attack_target_type

	#Heal
	has_heal = cardResource.has_heal
	heal_value = cardResource.heal_value

	#Buff
	has_self_buff = cardResource.has_self_buff
	
	has_damage_buff = cardResource.has_damage_buff
	damage_buff_value = cardResource.damage_buff_value
		
	has_defense_buff = cardResource.has_defense_buff
	defense_buff_value = cardResource.defense_buff_value
			
	#Enemy Debuff
	has_enemy_debuff = cardResource.has_enemy_debuff

	has_enemy_attack_debuff = cardResource.has_enemy_attack_debuff
	enemy_attack_debuff_value = cardResource.enemy_attack_debuff_value
		
	has_enemy_defense_debuff = cardResource.has_enemy_defense_debuff
	enemy_defense_debuff_value = cardResource.enemy_defense_debuff_value

	has_enemy_damage_poison = cardResource.has_enemy_damage_poison
	enemy_damage_poison_value = cardResource.enemy_damage_poison_value

	#Self Debuff
	has_self_debuff = cardResource.has_self_debuff

	has_self_damage_debuff = cardResource.has_self_damage_debuff
	damage_self_debuff_value = cardResource.damage_self_debuff_value
		
	has_self_defense_debuff = cardResource.has_self_defense_debuff
	self_defense_debuff_value = cardResource.self_defense_debuff_value
			
func playCard(target:String):
	
	# Attack Part
	if has_attack:
		#attack_enemy(attack_damage_value, target)
		actionDictionary["attack_enemy"] = attack_damage_value
		
	# Heal Part
	if has_heal:
		#heal_self(heal_value)
		actionDictionary["heal_self"] = heal_value

	# Self Buff
	if has_self_buff:
		if has_damage_buff:
			#apply_self_damage_buff(damage_buff_value)
			actionDictionary["apply_self_damage_buff"] = damage_buff_value
		if has_defense_buff:
			#apply_self_defense_buff(defense_buff_value)
			actionDictionary["apply_self_defense_buff"] = defense_buff_value

	# Enemy Debuff
	if has_enemy_debuff:
		if has_enemy_attack_debuff:
			#apply_enemy_damage_debuff(damage_enemy_debuff_value, target)
			actionDictionary["apply_enemy_attack_debuff"] = enemy_attack_debuff_value
		if has_enemy_defense_debuff:
			#apply_enemy_defense_debuff(enemy_defense_debuff_value, target)
			actionDictionary["apply_enemy_defense_debuff"] = enemy_defense_debuff_value
		if has_enemy_damage_poison:
			#apply_enemy_poison(enemy_damage_poison_value, target)
			actionDictionary["apply_enemy_poison"] = enemy_damage_poison_value
			
	# Self Debuf
	if has_self_debuff:
		if has_self_damage_debuff:
			#apply_self_damage_debuff(damage_self_debuff_value)
			actionDictionary["apply_self_damage_debuff"] = damage_self_debuff_value
		if has_self_defense_debuff:
			#apply_self_defense_debuff(self_defense_debuff_value)
			actionDictionary["apply_self_defense_debuff"] = self_defense_debuff_value
	
	card_istance.apply_card_action.emit(actionDictionary)
	#emette il segnale
func attack_enemy(damage: float, target: String):
	print("attack " + target + " enemy with:" + str(damage))

func heal_self(heal: float):
	print("heal self of with:" + str(heal))

# Buff
func apply_self_damage_buff(damage_buff: float):
	print("self damage buff:" + str(damage_buff))

func apply_self_defense_buff(defense_buff: float):
	print("self defense buff:" + str(defense_buff))
	
# Enemy Debuff
func apply_enemy_attack_debuff(damage_enemy_debuff: float, target: String):
	print("add attack debuff to  " + target + " enemy with:" + str(damage_enemy_debuff))

func apply_enemy_defense_debuff(enemy_defense_debuff: float, target: String):
	print("add defense debuff to  " + target + " enemy with:" + str(enemy_defense_debuff))

func apply_enemy_poison(damage_enemy_debuff: float, target: String):
	print("ad poison to " + target + " enemy with:" + str(damage_enemy_debuff))

# Self Debuff
func apply_self_damage_debuff(damage_self_debuff):
	print("self attack debuff:" + str(damage_self_debuff))
	
func apply_self_defense_debuff(self_defense_debuff):
	print("self defense debuff:" + str(self_defense_debuff))
