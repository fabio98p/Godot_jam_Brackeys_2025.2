extends Node2D

var currentPage = 1

@onready var next_page_button: Button = $NextPage
@onready var previus_page_button: Button = $PreviusPage
@onready var label: Label = $Label
@onready var image: Sprite2D = $Image

func _ready() -> void:
	loadNewPage()

func _on_next_page_pressed() -> void:
	currentPage += 1
	if currentPage >= 5:
		GC.willingAudio(preload("res://Assets/Music/Music/GamePlayBGMLoop.mp3"),0.1)
		get_tree().change_scene_to_file("res://Levels/level_1.tscn")
		return
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")
	loadNewPage()

func _on_previus_page_pressed() -> void:
	currentPage -= 1
	loadNewPage()
	Utils.play_sfx(Pools.BookmarksPageFlip[randi_range(0,Pools.BookmarksPageFlip.size()-1)], "SFX")

func getFileThing(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content 

func loadNewPage():
	# start sound
	#var narratorPath = load("res://Assets/Narration/NarrationPage" + str(currentPage) + ".mp3" as String)
	var narratorPath = load("res://Levels/StoryMode/Narrator/NarrationPage" + str(currentPage) + ".mp3")
	GC.willingAudio(narratorPath, 0.2)
	
	#change text
	var narratorTextPath: String = "res://Levels/StoryMode/PageText/page" + str(currentPage) + ".txt"
	label.text = getFileThing(narratorTextPath)

	#change image
	var imagePath: String = "res://Levels/StoryMode/Image/image" + str(currentPage) + ".jpg"
	image.texture = load(imagePath)
