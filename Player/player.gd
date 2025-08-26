extends Node2D

@export var max_health: float
@export var max_sanity: int
var current_health: float
var current_sanity: int
var attack_multiply: float = 1.0
var defense_multiply: float = 1.0
@onready var health: Label = $health
@onready var sanity: Label = $sanity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	current_sanity = max_sanity
	health.text = "max_healt: " + str(current_health)
	sanity.text = "max_sanity: " + str(current_sanity)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func dmg_taken(value):
	
	current_health = current_health - value
	health.text = "max_healt: " + str(current_health)
	if current_health <= 0:
		health.text = "max_healt: " +  "dead health"

func heal_self(value):
	
	if current_health <= max_health:
		health.text = "max_healt: " + str(current_health)
		current_health = current_health + value
	

func sanity_taken(value):
	
	current_sanity = current_sanity - value
	sanity.text = "max_sanity: " + str(current_sanity)
	if current_sanity <= 0:
		sanity.text = "max_sanity: " + "dead sanity"
