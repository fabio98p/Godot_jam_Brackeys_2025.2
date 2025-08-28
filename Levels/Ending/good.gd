extends Node2D

func _ready() -> void:
	GC.resetDeck()
	GC.numberOfFight = 0
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
