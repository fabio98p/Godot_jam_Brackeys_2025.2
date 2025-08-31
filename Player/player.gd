extends Node2D

@export var max_health: float = 100.0
@export var max_sanity: int = 100
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
var shield: int = 0:
	set(value):
		shield = clamp(value, 0, 10)
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
const HURT_TEXTURE: Texture2D = preload("res://Assets/Image/Alice_Hurt_Final.png")
const SANITY_HURT_TEXTURE: Texture2D = preload("res://Assets/Alice_Sanity_Hurt.png")
const NORMAL_TEXTURE: Texture2D = preload("res://Assets/Alice_Normal.png")

func _ready() -> void:
	#health_bars.max_health = max_health
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
	sprite_2d.visible = false
	animated_sprite_2d.stop()
	animated_sprite_2d.play("insane")
	animated_sprite_2d.speed_scale = 1.0
	var durations = 5.0  
	var target_speed = 6.0 
	var elapseds = 0.0
	while elapseds < duration:
		var t = elapseds / durations
		animated_sprite_2d.speed_scale = lerp(1.0, target_speed, t)  # aumenta gradualmente
		await get_tree().process_frame
		elapseds += get_process_delta_time()
		#var elapsed = 0.0
		#while elapsed < duration:
			#var t = elapsed / duration  # normalizzato 0..1
			## esponenziale: parte basso e cresce verso max
			#var intensity = lerp(0.5, max_intensity, t * t)  # t^2 per esponenziale
			#var rotation_intensity = lerp(0.5, max_rotation, t * t)
			#
			#var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
			#sprite_2d.position = original_position + offset
			#sprite_2d.rotation_degrees = randf_range(-rotation_intensity, rotation_intensity)
			#
			#await get_tree().process_frame
			#elapsed += get_process_delta_time()
		#
		#sprite_2d.position = original_position
		#sprite_2d.rotation_degrees = 0


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
		Utils.play_sfx("res://Assets/SFX/SFX/ShieldFinal.mp3", "SFX")
	else:
		Utils.play_sfx("res://Assets/SFX/SFX/AttackFinal.mp3", "SFX")
	# Applico danno
	current_health -= damage_after_shield
	shieldLabel.text = "shield value: " + str(shield)

	# Cambio skin a "hurt" e tremolio
	sprite_2d.texture = HURT_TEXTURE
	shake_sprite(2.0, 0.2)
	reset_skin_later()

	# Aggiorno testo vita
	if current_health > 0:
		health.text = "max_health: " + str(current_health)
	else:
		animated_sprite_2d.stop()
		
		health.text = "max_health: dead health"
		emit_signal("dead", {"scene":"res://Levels/Ending/Dead.tscn", "audio":"res://Assets/Music/Music/1SanityPointEnding.mp3"})



func sanity_taken(value: int) -> void:
	current_sanity -= value
	sanity.text = "max_sanity: " + str(current_sanity)

	# Cambio skin a "sanity hurt" e tremolio
	sprite_2d.texture = SANITY_HURT_TEXTURE
	insane_shake(0.5, 0.4, 0.5)  # tremolio pazzoide
	reset_skin_later()
	start_charge_attack()

	if current_sanity <= 0:
		sanity.text = "max_sanity: dead sanity"
		emit_signal("dead",  {"scene": "res://Levels/Ending/Sanity.tscn", "audio": "res://Assets/Music/Music/InsanityGameOver.mp3"})


func reset_skin_later() -> void:
	scale = Vector2(1.0, 1.0)
	animated_sprite_2d.visible = false
	await get_tree().create_timer(0.5).timeout
	scale = Vector2(0.5, 0.5)
	animated_sprite_2d.visible = true
	if current_health > 0 and current_sanity > 0:
		#sprite_2d.texture = NORMAL_TEXTURE
		pass
	if current_sanity <= 0:
		insane_shake_exponential(6.4, 4.0, 5.0) 
	if current_health <=0:
		animated_sprite_2d.stop()
		animated_sprite_2d.visible = false
		scale = Vector2(1.0, 1.0)
		sprite_2d.texture = HURT_TEXTURE


func heal_self(value: int) -> void:
	if current_health < max_health:
		current_health = min(current_health + value, max_health)
		health.text = "max_health: " + str(current_health)

func start_charge_attack() -> void:
	# wrapper che "stacca" la coroutine
	await get_tree().create_timer(1).timeout
	await player_charge_attack()
func start_buff_animation() -> void:
	await get_tree().create_timer(1).timeout
	await jump_animation()

func player_charge_attack(forward_offset: float = -15.0, back_offset: float = 40.0, prep_time: float = 0.15, hold_time: float = 0.25, attack_time: float = 0.08, recover_time: float = 0.15) -> void:
	var tween = create_tween()
	var original_pos = position

	# Slide iniziale (preparazione)
	tween.tween_property(self, "position", original_pos + Vector2(forward_offset, 0), prep_time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Pausa in preparazione
	tween.tween_interval(hold_time)

	# Scatto violento nella direzione opposta
	tween.tween_property(self, "position", original_pos + Vector2(back_offset, 0), attack_time)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	# Ritorno alla posizione originale
	tween.tween_property(self, "position", original_pos, recover_time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Shake finale per impatto
	for i in range(2):
		tween.tween_property(self, "position", original_pos + Vector2(randf_range(-3, 3), randf_range(-2, 2)), 0.03)
		tween.tween_property(self, "position", original_pos, 0.03)

	await tween.finished
	print("Attacco completato!")


func jump_animation(up_offset: float = -40.0, prep_time: float = 0.15, hold_time: float = 0.1, fall_time: float = 0.2, recover_time: float = 0.1) -> void:
	var tween = create_tween()
	var original_pos = position


	tween.tween_property(self, "position", original_pos + Vector2(0, up_offset), prep_time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.tween_interval(hold_time)

	tween.tween_property(self, "position", original_pos, fall_time)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	tween.tween_property(self, "position", original_pos + Vector2(0, up_offset*0.2), recover_time/2)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", original_pos, recover_time/2)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	for i in range(2):
		tween.tween_property(self, "position", original_pos + Vector2(randf_range(-3,3), randf_range(-3,3)), 0.03)
		tween.tween_property(self, "position", original_pos, 0.03)

	await tween.finished
	print("Balzo")
