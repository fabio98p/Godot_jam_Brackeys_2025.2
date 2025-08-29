extends Node2D

@export var max_health: float = 100.0
@export var max_sanity: int = 100

signal dead

@onready var attack_multi: Label = $AttackMulti
@onready var defense_multi: Label = $DefenseMulti
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health: Label = $health
@onready var sanity: Label = $sanity
@onready var shieldLabel: Label = $Shield

var current_health: float
var current_sanity: int
var shield: int = 0

# moltiplicatori di attacco/difesa
var attack_multiply: float = 0:
	set(value):
		attack_multiply = clamp(attack_multiply + value, -3, 3)
		attack_multi.text = "attack multy: " + str(attack_multiply)

var defense_multiply: float = 0:
	set(value):
		defense_multiply = clamp(defense_multiply + value, -3, 3)
		defense_multi.text = "defense multy: " + str(defense_multiply)

# texture
const HURT_TEXTURE: Texture2D = preload("res://Assets/Alice_Hurt.png")
const SANITY_HURT_TEXTURE: Texture2D = preload("res://Assets/Alice_Sanity_Hurt.png")
const NORMAL_TEXTURE: Texture2D = preload("res://Assets/Alice_Normal.png")

func _ready() -> void:
	current_health = max_health
	current_sanity = max_sanity
	health.text = "max_health: " + str(current_health)
	sanity.text = "max_sanity: " + str(current_sanity)
	attack_multi.text = "attack multy: " + str(attack_multiply)
	defense_multi.text = "defense multy: " + str(defense_multiply)
	shieldLabel.text = "shield value: " + str(shield)
	sprite_2d.texture = NORMAL_TEXTURE

func dmg_taken(value: int) -> void:
	var damage_after_shield = value
	# Calcolo danno con scudo
	if shield > 0:
		if shield >= value:
			shield -= value
			damage_after_shield = 0
		else:
			damage_after_shield = value - shield
			shield = 0
	# Applico danno
	current_health -= damage_after_shield
	shieldLabel.text = "shield value: " + str(shield)
	# Cambio skin a "hurt" e reset dopo poco
	sprite_2d.texture = HURT_TEXTURE
	reset_skin_later()

	# Aggiorno testo vita
	if current_health > 0:
		health.text = "max_health: " + str(current_health)
	else:
		health.text = "max_health: dead health"
		emit_signal("dead", "res://Levels/Ending/Dead.tscn")

# torna a normale dopo un breve delay
func reset_skin_later() -> void:
	await get_tree().create_timer(0.5).timeout
	# Se Alice non è morta e non ha sanity a 0, torna normale
	if current_health > 0 and current_sanity > 0:
		sprite_2d.texture = NORMAL_TEXTURE

func heal_self(value: int) -> void:
	if current_health < max_health:
		current_health = min(current_health + value, max_health)
		health.text = "max_health: " + str(current_health)


func sanity_taken(value: int) -> void:
	current_sanity -= value
	sanity.text = "max_sanity: " + str(current_sanity)
	# Cambio skin a "sanityhurt" e reset dopo poco
	sprite_2d.texture = SANITY_HURT_TEXTURE
	reset_skin_later()
	if current_sanity <= 0:
		sanity.text = "max_sanity: dead sanity"
		emit_signal("dead", "res://Levels/Ending/Sanity.tscn")
		#await get_tree().create_timer(7).timeout
		#get_tree().change_scene_to_file("res://Levels/Ending/Sanity.tscn")
