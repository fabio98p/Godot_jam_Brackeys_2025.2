extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")

func _on_credits_pressed() -> void:
	print("start credits")

func _on_exit_pressed() -> void:
	get_tree().quit()
