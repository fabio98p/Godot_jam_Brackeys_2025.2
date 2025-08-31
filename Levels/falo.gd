extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var button_1: Button = $Button1
@onready var button_2: Button = $Button2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GC.pickenemy()
	GC.player_actually_health = -1
	GC.player_actually_sanity = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_1_pressed() -> void:
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")


func _on_button_2_pressed() -> void:
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")
