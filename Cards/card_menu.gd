extends Node2D

var starting_position
@onready var img: Sprite2D = $Sprite2D
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
	get_parent().connect_card_signals(self)
	#cardDataHandler.playCard("ciao")

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func destroy_card():
	queue_free()
