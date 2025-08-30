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
		attack_multiply = clamp(attack_multiply + value,-3,3)
		attack_multi.text =  "attack multy: " + str(attack_multiply)
var defense_multiply: float = 0:
	set(value):
		defense_multiply = clamp(defense_multiply + value,-3,3)
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
