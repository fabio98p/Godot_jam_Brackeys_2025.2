extends Node2D

var currentPage = 1

@onready var next_page_button: Button = $NextPage
@onready var previus_page_button: Button = $PreviusPage
@onready var label: Label = $Label
@onready var image: Sprite2D = $Image

func _ready() -> void:
	pass

func _on_next_page_pressed() -> void:
	
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
	get_tree().change_scene_to_file("res://Menus/Main_menu_cards.tscn")
	

func _on_previus_page_pressed() -> void:
	currentPage -= 1
	
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
