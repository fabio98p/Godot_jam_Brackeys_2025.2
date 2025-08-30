extends Node2D

var starting_position
@export var cardResource: CardResource
var cardDataHandler: CardDataHandler

@onready var img: Sprite2D = $Sprite2D
@onready var nameCard: Label = $Name
@onready var desc: Label = $Desc
@onready var attack: Label = $Attack
@onready var heal: Label = $Heal
@onready var buff_attack: Label = $BuffAttack
@onready var buff_defense: Label = $BuffDefense
@onready var card_type: HBoxContainer = $CardType

signal hovered
signal hovered_off
signal apply_card_action

func _ready() -> void:
	get_parent().get_parent().connect_card_signals(self)
	cardDataHandler = CardDataHandler.new(cardResource, self)
	img.texture = cardDataHandler.img
	img.scale = cardDataHandler.img_size
	nameCard.text = "name: " + cardDataHandler.cardName
	desc.text = "desc: " + cardDataHandler.description
	attack.text = "attack: " + str(cardDataHandler.attack_damage_value)
	heal.text = "heal: " + str(cardDataHandler.heal_value)
	buff_attack.text = "buffattack: " + str(cardDataHandler.damage_buff_value)
	buff_defense.text = "buffdefense: " + str(cardDataHandler.defense_buff_value)
	
	## Card Type
	#if cardDataHandler.has_attack:
		#var textureReactIstance: TextureRect = TextureRect.new()
		#textureReactIstance.texture = preload("res://Assets/CardsImg/IMG_8221.png")
		#card_type.add_child(textureReactIstance)
	#if cardDataHandler.has_shield:
		#var textureReactIstance: TextureRect = TextureRect.new()
		#textureReactIstance.texture = preload("res://Assets/CardsImg/IMG_8222.png")
		#card_type.add_child(textureReactIstance)
	#if cardDataHandler.has_self_buff:
		#var textureReactIstance: TextureRect = TextureRect.new()
		#textureReactIstance.texture = preload("res://Assets/CardsImg/IMG_8222.png")
		#card_type.add_child(textureReactIstance)
	#if cardDataHandler.has_enemy_debuff:
		#var textureReactIstance: TextureRect = TextureRect.new()
		#textureReactIstance.texture = preload("res://Assets/CardsImg/IMG_8224.png")
		#card_type.add_child(textureReactIstance)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func destroy_card():
	#mettere animazione del crounch
	queue_free()
