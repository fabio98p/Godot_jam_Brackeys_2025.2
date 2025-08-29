extends Node2D

func _ready() -> void:
	GC.audioStop()
	GC.resetDeck()
	GC.numberOfFight = 0
	GC.willingAudio(preload("res://Assets/Music/Music/GoodEnding.mp3"), 0.1)
