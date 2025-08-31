extends TextureRect
@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3

var nextAttack: EnemyAttack

func _ready() -> void:
	label.visible = false
	label_2.visible = false
	label_3.visible = false

func updateNewtAttack(newNextAttack):
	nextAttack = newNextAttack
	label_2.text = ""
	label_3.text = ""
	# Shield
	if nextAttack.has_shield: 
		if label_2.text == "":
			label_2.text = "Give Shield: " + str(nextAttack.shield_value)
		else:
			label_3.text = "Give Shield: " + str(nextAttack.shield_value)
	# Heal
	if nextAttack.has_heal:
		if label_2.text == "":
			label_2.text = "Give Heal: " + str(nextAttack.heal_value)
		else:
			label_3.text = "Give Heal: " + str(nextAttack.heal_value)
	# Self Buff
	if nextAttack.has_self_buff:
		if nextAttack.has_self_attack_buff:
			if label_2.text == "":
				label_2.text = "Give Attack Buff: " + str(nextAttack.self_attack_buff )
			else:
				label_3.text = "Give Attack Buff: " + str(nextAttack.self_attack_buff )

		if nextAttack.has_self_defense_buff:
			if label_2.text == "":
				label_2.text = "Give Defense Buff: " + str(nextAttack.self_defense_buff  )
			else:
				label_3.text = "Give Defense Buff: " + str(nextAttack.self_defense_buff  )
	
	# Player Debuff
	if nextAttack.has_player_debuff: 
		if nextAttack.has_player_attack_debuff:
			if label_2.text == "":
				label_2.text = "Set Player Attack Debuff: " + str(nextAttack.player_attack_debuff )
			else:
				label_3.text = "Set Player Attack Debuff: " + str(nextAttack.player_attack_debuff )
		if nextAttack.has_player_defense_debuff:
			if label_2.text == "":
				label_2.text = "Set Player Defense Debuff: " + str(nextAttack.player_defense_debuff )
			else:
				label_3.text = "Set Player Defense Debuff: " + str(nextAttack.player_defense_debuff )
	
	# Attack must be the last
	if nextAttack.has_attack: 
		var finalMoltiplicator = clamp(1 + (get_parent().enemy.attack_multiply*0.25) - (get_parent().enemy.defense_multiply*0.25),0,3)
		var enemy_attack_damage = nextAttack.attack_damage * finalMoltiplicator
		if label_2.text == "":
			label_2.text = "Attack Damage: " + str(enemy_attack_damage)
		else:
			label_3.text = "Attack Damage: " + str(enemy_attack_damage)


func _on_mouse_entered() -> void:
	label.visible = true
	label_2.visible = true
	label_3.visible = true


func _on_mouse_exited() -> void:
	label.visible = false
	label_2.visible = false
	label_3.visible = false
