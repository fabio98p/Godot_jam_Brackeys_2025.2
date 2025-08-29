extends Node2D

func _ready() -> void:
	GC.audioStop()
	GC.resetDeck()
	GC.numberOfFight = 0
