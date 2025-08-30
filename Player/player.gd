extends Node2D

@export var max_health: float = 100.0
@export var max_sanity: int = 100

signal dead
@onready var health_bars: Control = $Bars

@onready var attack_multi: Label = $AttackMulti
@onready var defense_multi: Label = $DefenseMulti
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health: Label = $health
@onready var sanity: Label = $sanity
@onready var shieldLabel: Label = $Shield

var current_health: float
var current_sanity: int
var shield: int = 0
var original_position: Vector2

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
	health_bars.max_health = max_health
	current_health = max_health
	current_sanity = max_sanity
	health.text = "max_health: " + str(current_health)
	sanity.text = "max_sanity: " + str(current_sanity)
	attack_multi.text = "attack multy: " + str(attack_multiply)
	defense_multi.text = "defense multy: " + str(defense_multiply)
	shieldLabel.text = "shield value: " + str(shield)
	sprite_2d.texture = NORMAL_TEXTURE
	original_position = sprite_2d.position


func shake_sprite(intensity: float = 2.0, duration: float = 0.2, bounce: float = 3.0) -> void:
	var elapsed = 0.0
	while elapsed < duration:
		# tremolio orizzontale e verticale
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		offset.y -= sin(elapsed / duration * PI) * bounce
		sprite_2d.position = original_position + offset
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	# torna alla posizione originale
	sprite_2d.position = original_position

func insane_shake(intensity: float = 4.0, duration: float = 0.5, rotation_intensity: float = 5.0) -> void:
	var elapsed = 0.0
	while elapsed < duration:
		# Posizione casuale folle
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		sprite_2d.position = original_position + offset
		
		# Piccola rotazione casuale
		sprite_2d.rotation_degrees = randf_range(-rotation_intensity, rotation_intensity)
		
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	# Torna normale
	sprite_2d.position = original_position
	sprite_2d.rotation_degrees = 0

func insane_shake_exponential(duration: float = 6.4, max_intensity: float = 4.0, max_rotation: float = 5.0) -> void:
	var elapsed = 0.0
	while elapsed < duration:
		var t = elapsed / duration  # normalizzato 0..1
		# esponenziale: parte basso e cresce verso max
		var intensity = lerp(0.5, max_intensity, t * t)  # t^2 per esponenziale
		var rotation_intensity = lerp(0.5, max_rotation, t * t)
		
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		sprite_2d.position = original_position + offset
		sprite_2d.rotation_degrees = randf_range(-rotation_intensity, rotation_intensity)
		
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	sprite_2d.position = original_position
	sprite_2d.rotation_degrees = 0


func dmg_taken(value: int) -> void:
	var damage_after_shield = value
	# Calcolo danno con scudo
	if shield > 0:
		if shield >= value:
			shield -= value
			damage_after_shield = 0
			health_bars.set_Shield_Value = shield
		else:
			damage_after_shield = value - shield
			shield = 0
			health_bars.set_Shield_Value = 0
		Utils.play_sfx("res://Assets/SFX/SFX/ShieldFinal.mp3", "SFX")

	# Applico danno
	current_health -= damage_after_shield
	health_bars.minus_progress_bars(current_health)
	Utils.play_sfx("res://Assets/SFX/SFX/AttackFinal.mp3", "SFX")
	shieldLabel.text = "shield value: " + str(shield)

	# Cambio skin a "hurt" e tremolio
	sprite_2d.texture = HURT_TEXTURE
	shake_sprite(2.0, 0.2)
	reset_skin_later()

	# Aggiorno testo vita
	if current_health > 0:
		health.text = "max_health: " + str(current_health)
	else:
		health.text = "max_health: dead health"
		emit_signal("dead", {"scene":"res://Levels/Ending/Dead.tscn", "audio":"res://Assets/Music/Music/1SanityPointEnding.mp3"})



func sanity_taken(value: int) -> void:
	current_sanity -= value
	sanity.text = "max_sanity: " + str(current_sanity)

	# Cambio skin a "sanity hurt" e tremolio
	sprite_2d.texture = SANITY_HURT_TEXTURE
	insane_shake(0.5, 0.4, 0.5)  # tremolio pazzoide
	reset_skin_later()

	if current_sanity <= 0:
		sanity.text = "max_sanity: dead sanity"
		emit_signal("dead",  {"scene": "res://Levels/Ending/Sanity.tscn", "audio": "res://Assets/Music/Music/InsanityGameOver.mp3"})


func reset_skin_later() -> void:
	await get_tree().create_timer(0.5).timeout
	if current_health > 0 and current_sanity > 0:
		sprite_2d.texture = NORMAL_TEXTURE
	if current_sanity <= 0:
		insane_shake_exponential(6.4, 4.0, 5.0) 


func heal_self(value: int) -> void:
	if current_health < max_health:
		current_health = min(current_health + value, max_health)
		health_bars.minus_progress_bars(current_health)
		health.text = "max_health: " + str(current_health)
