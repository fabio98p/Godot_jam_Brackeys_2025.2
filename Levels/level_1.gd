extends Node2D
@onready var player: Node2D = $Player
@onready var enemy: Node2D = $Enemy

func applay_card_effect(cadsEffect):
	print("ciaone")
	print(cadsEffect)
	for key in cadsEffect.keys():
		var value = cadsEffect[key]
		print("Effetto:", key, " -> ", value)

		match key:
			"sanity_cost":
				player.sanity_taken(value)
			"attack_enemy":
				enemy.dmg_taken(value)
			"heal_self":
				player.heal_self(value)
