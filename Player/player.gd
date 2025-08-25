extends Node2D

@export var max_health: float
@export var max_sanity: int
var current_health: float
var current_sanity: int
@onready var health: Label = $health
@onready var sanity: Label = $sanity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	current_sanity = max_sanity
	health.text = "max_healt: " + str(current_health)
	sanity.text = "max_sanity: " + str(current_sanity)
	await get_tree().create_timer(2).timeout
	dmg_taken()
	sanity_taken()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func dmg_taken():
	print(current_health)
	current_health -= 1 
	health.text = "max_healt: " + str(current_health)
	if current_health <= 0:
		health.text = "max_healt: " +  "dead health"
		

func sanity_taken():
	print(current_sanity)
	current_sanity -= 1 
	sanity.text = "max_sanity: " + str(current_sanity)
	if current_health <= 0:
		sanity.text = "max_sanity: " + "dead sanity"
		
