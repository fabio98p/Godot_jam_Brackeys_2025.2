extends Node2D

@export var max_health: float
@export var max_sanity: int
@onready var attack_multi: Label = $AttackMulti
@onready var defense_multi: Label = $DefenseMulti

var current_health: float
var current_sanity: int
var shield: int = 0

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
		
@onready var health: Label = $health
@onready var sanity: Label = $sanity
@onready var shieldLabel: Label = $Shield


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	current_sanity = max_sanity
	health.text = "max_healt: " + str(current_health)
	sanity.text = "max_sanity: " + str(current_sanity)
	attack_multi.text =  "attack multy: " + str(attack_multiply)
	defense_multi.text = "defense multy: " + str(defense_multiply)
	shieldLabel.text = "shield value: " + str(shield)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func dmg_taken(value):
	#current_health = current_health - (value - shield)
	#health.text = "max_healt: " + str(current_health)
	#if current_health <= 0:
		#health.text = "max_healt: " +  "dead health"

func dmg_taken(value: int) -> void:
	var damage_after_shield = value
	
	if shield > 0:
		if shield >= value:
			shield -= value
			damage_after_shield = 0
		else:
			damage_after_shield = value - shield
			shield = 0
	current_health -= damage_after_shield
	shieldLabel.text = "shield value: " + str(shield)
	if current_health > 0:
		health.text = "max_health: " + str(current_health)
	else:
		health.text = "max_health: dead health"
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Levels/Ending/Dead.tscn")




func heal_self(value):
	if current_health <= max_health:
		health.text = "max_healt: " + str(current_health)
		current_health = current_health + value
	
func sanity_taken(value):
	current_sanity = current_sanity - value
	sanity.text = "max_sanity: " + str(current_sanity)
	if current_sanity <= 0:
		sanity.text = "max_sanity: " + "dead sanity"
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Levels/Ending/Sanity.tscn")
