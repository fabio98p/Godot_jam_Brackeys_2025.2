extends Node2D

signal enemy_dead

@export var enemyResource: EnemyResource
@onready var health_bars: Control = $Bars

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var nameEnemy: Label = $Name
@onready var desc: Label = $Desc
@onready var health: Label = $Healt
@onready var next_attack: Label = $NextAttack
@onready var attack_multi: Label = $AttackMulti
@onready var defense_multi: Label = $DefenseMulti
@onready var shieldLabel: Label = $Shield

var shield: int = 0:
	set(value):
		shield = clamp(value, 0, 10)
# attack and defense have max of 3 multiply,
# every multiply is a x0.25 of damage for a max of *1.75 or 
var attack_multiply: float = 0:
	set(value):
		attack_multiply = clamp(value,-3,3)
		attack_multi.text =  "attack multy: " + str(attack_multiply)
var defense_multiply: float = 0:
	set(value):
		defense_multiply = clamp(value,-3,3)
		defense_multi.text = "defense multy: " + str(defense_multiply)
var current_health: float

var new_attack: EnemyAttack

var enemyDataHandler: EnemyDataHandler
func _ready() -> void:
	
	#health_bars.max_health = enemyResource.max_healt
	var enemy_data: EnemyResource = enemyResource.duplicate()
	enemyDataHandler = EnemyDataHandler.new(enemy_data)
	
	nameEnemy.text = "name: " + enemyDataHandler.enemy_name
	desc.text = "desc: " + enemyDataHandler.description
	health.text = "max_healt: " + str(enemyDataHandler.max_healt)
	new_attack = enemyDataHandler.getNextAttack()
	next_attack.text = "next_attack: " + str(new_attack.attack_damage)
	attack_multi.text =  "attack multy: " + str(attack_multiply)
	defense_multi.text = "defense multy: " + str(defense_multiply)
	shieldLabel.text = "Shield: " + str(shield)
	
	#handle animation
	var anim := create_idle_anim(enemyDataHandler.animation)
	anim.scale = enemyDataHandler.animation.scale
	if enemyDataHandler.animation.position:
		anim.position = enemyDataHandler.animation.position
	else: 
		anim.position = Vector2(1000.0,400.0)
	add_child(anim)
	#sprite_2d.texture = enemyDataHandler.img
	
#func dmg_taken(value):
	#print("enemy current",enemyDataHandler.current_healt)
	#enemyDataHandler.current_healt = enemyDataHandler.current_healt - value 
	#health.text = "max_healt: " + str(enemyDataHandler.current_healt)
	#if enemyDataHandler.current_healt <= 0:
		#health.text = "max_healt: " +  "dead health"

func enemy_dmg_taken(value: int) -> void:

	var damage_after_shield = value
	
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
	shieldLabel.text = "Shield: " + str(shield)
	enemyDataHandler.current_healt -= damage_after_shield
	current_health = enemyDataHandler.current_healt
	if enemyDataHandler.current_healt > 0:
		health.text = "max_healt: " + str(enemyDataHandler.current_healt)
	else:
		health.text = "max_healt: dead health"
		visible = false
		enemy_dead.emit()

func applay_next_attack():
	var old_next_attack : EnemyAttack = new_attack
	new_attack = enemyDataHandler.getNextAttack()
	next_attack.text = "next_attack: " + str(new_attack.attack_damage)
	return old_next_attack


func create_idle_anim(res: EnemyAnimationResource) -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	var frames := SpriteFrames.new()

	frames.add_animation("idle")
	frames.set_animation_speed("idle", res.fps)
	frames.set_animation_loop("idle", true)

	# Calcolo numero di frame nella sprite sheet
	var cols := res.sprite_sheet.get_width() / res.frame_size.x
	var rows := res.sprite_sheet.get_height() / res.frame_size.y

	var base_img: Image = res.sprite_sheet.get_image()
	for y in rows:
		for x in cols:
			var rect := Rect2(Vector2i(x, y) * res.frame_size, res.frame_size)
			var img: Image = base_img.get_region(rect)
			var frame_tex: ImageTexture = ImageTexture.create_from_image(img)
			frames.add_frame("idle", frame_tex)

	sprite.frames = frames
	sprite.animation = "idle"
	sprite.play("idle")

	return sprite

func start_charge_attack() -> void:
	# wrapper che "stacca" la coroutine
	await get_tree().create_timer(2).timeout
	await charge_attack()

func start_buff_animation() -> void:
	await get_tree().create_timer(1).timeout
	await jump_animation()

func charge_attack(forward_offset: float = 15.0, back_offset: float = -40.0, prep_time: float = 0.15, hold_time: float = 0.25, attack_time: float = 0.08, recover_time: float = 0.15) -> void:
	var tween = create_tween()
	var original_pos = position

	tween.tween_property(self, "position", original_pos + Vector2(forward_offset, 0), prep_time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	
	tween.tween_interval(hold_time)

	
	tween.tween_property(self, "position", original_pos + Vector2(back_offset, 0), attack_time)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	
	tween.tween_property(self, "position", original_pos, recover_time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	
	for i in range(2):
		tween.tween_property(self, "position", original_pos + Vector2(randf_range(-3, 3), randf_range(-2, 2)), 0.03)
		tween.tween_property(self, "position", original_pos, 0.03)

	await tween.finished
	print("Attacco")
	
func jump_animation(up_offset: float = -40.0, prep_time: float = 0.15, hold_time: float = 0.1, fall_time: float = 0.2, recover_time: float = 0.1) -> void:
	var tween = create_tween()
	var original_pos = position

	Utils.play_sfx("res://Assets/SFX/SFX/DebuffFinal.mp3", "SFX")
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
