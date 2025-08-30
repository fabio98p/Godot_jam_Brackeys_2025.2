extends Node2D

func _ready() -> void:
	GC.resetDeck()
	GC.numberOfFight = 0


func _on_audio_stream_player_2d_finished() -> void:
	get_tree().change_scene_to_file("res://Menus/Main_menu_cards.tscn")
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/Main_menu_cards.tscn")
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
