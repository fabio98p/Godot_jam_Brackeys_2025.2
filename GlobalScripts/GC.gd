extends Node

var runDeck: Array[CardResource]

var initialDeck: Array[CardResource] = [
load("res://Cards/Resources/attack+heal.tres") as CardResource,
load("res://Cards/Resources/heal.tres") as CardResource,
load("res://Cards/Resources/attack.tres") as CardResource,
load("res://Cards/Resources/attack+heal.tres") as CardResource,
load("res://Cards/Resources/heal.tres") as CardResource,
load("res://Cards/Resources/attack.tres") as CardResource,
load("res://Cards/Resources/attack+heal.tres") as CardResource,
load("res://Cards/Resources/heal.tres") as CardResource,
load("res://Cards/Resources/attack.tres") as CardResource
]

func _init() -> void:
	resetDeck()

func resetDeck():
	runDeck = initialDeck
	
