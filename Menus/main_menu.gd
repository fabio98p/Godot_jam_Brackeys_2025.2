extends Control

@onready var fmod_event_emitter_2d: FmodEventEmitter2D = $FmodEventEmitter2D

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")

func _on_option_pressed() -> void:
	print("test")
	fmod_event_emitter_2d.play()

func _on_exit_pressed() -> void:
	get_tree().quit()
