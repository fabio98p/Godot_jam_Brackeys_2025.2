extends Node2D

var starting_position
@export var cardResource: CardResource
var cardDataHandler: CardDataHandler 
	
signal hovered
signal hovered_off

func _ready() -> void:
	get_parent().get_parent().connect_card_signals(self)
	
	cardDataHandler = CardDataHandler.new(cardResource)
	cardDataHandler.playCard("ciao")

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
