extends Node2D

var starting_position
@export var cardResource: CardResource
var cardDataHandler: CardDataHandler 

@onready var nameCard: Label = $Name
@onready var desc: Label = $Desc
@onready var attack: Label = $Attack
@onready var heal: Label = $Heal
@onready var buff_attack: Label = $BuffAttack
@onready var buff_defense: Label = $BuffDefense
	
signal hovered
signal hovered_off
signal apply_card_action

func _ready() -> void:
	
	cardDataHandler = CardDataHandler.new(cardResource, self)
	
	nameCard.text = "name: " + cardDataHandler.cardName
	desc.text = "desc: " + cardDataHandler.description
	attack.text = "attack: " + str(cardDataHandler.attack_damage_value)
	heal.text = "heal: " + str(cardDataHandler.heal_value)
	buff_attack.text = "buffattack: " + str(cardDataHandler.damage_buff_value)
	buff_defense.text = "buffdefense: " + str(cardDataHandler.defense_buff_value)
	
	#cardDataHandler.playCard("ciao")

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func destroy_card():
	#mettere animazione del crounch
	queue_free()
