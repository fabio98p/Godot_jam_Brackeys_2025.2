extends Node2D

var currentPage = 1

@onready var next_page_button: Button = $NextPage
@onready var previus_page_button: Button = $PreviusPage
@onready var label: Label = $Label
@onready var image: Sprite2D = $Image

var text1: Array[String] = ["Alice sat quietly in her chair, the late afternoon light dimming behind the curtains. Her teacup rattled, though her hands did not shake. A soft ticking filled the room—though there was no clock to be seen. Then came a sudden crack, as though silver had splintered. The mirror across from her rippled, the surface quivering like water disturbed by a stone. From its depths leapt a familiar figure: the White Rabbit, waistcoat torn, ears trembling, eyes wide with urgency. “My dear Alice,” he panted, clutching his pocket watch though no time showed upon its face. “Wonderland is unraveling! You must come at once. Help us, and I promise—you’ll be back in time for tea.” Before she could answer, the glass stretched open like a mouth. The Rabbit vanished through, glancing over his shoulder with a pleading look. And then, despite the whisper of dread in her heart, Alice followed.",
"Hardly had Alice straightened her frock when a thunderous cry rang out: “There she is! After her!” A host of soldiers in crimson livery came charging through the hedgerows, their helmets bristling and their spears clattering. At their head strode the Red Queen herself, taller and sterner than Alice remembered, her eyes flashing like hot coals. “Run, child, run!” cried the White Rabbit, ears flat against his head as he darted ahead of her. His pocket watch swung wildly, its hands spinning without sense or reason. Alice, not at all inclined to argue with her friend just then, gathered her skirts and fled. She darted over brooks and under branches, her heart pounding as the Red Queen’s army thundered behind her. At last, breathless and near despair, Alice spied a pale light ahead. The Rabbit gave a final urging gesture, then vanished into the glow. Summoning her courage, Alice stumbled forward—into the quiet refuge of the White Queen’s abode…",
"After a most perilous flight, Alice at last found herself within the gentle comfort of the White Queen’s dwelling. A cheery fire flickered in the grate, while the delicious perfume of baking biscuits drifted through the chamber, filling Alice with a curious mixture of joy and relief. “My dearest child,” said the White Queen, adjusting her crown with an absent-minded air, “you are quite rumpled and altogether out of sorts. Pray, what misadventure has befallen you?” Alice gave a weary sigh. 'Your Majesty, you may think me quite mad, but I stepped through a mirror in my own parlour, and here I am. I have been pursued most dreadfully by the Red Queen’s soldiers, crashing through bramble and briar, and I would very much like to be home again in time for tea.'",
"The White Queen clapped her hands together as though Alice had spoken the most agreeable news. “Why, dear Alice, you have no cause for fretting, for I possess precisely the thing to restore you and to thwart the Red Queen besides. The power of biscuits!” “Biscuits?” Alice repeated, with an astonished blink. “Yes, biscuits!” cried the Queen, whisking a tray from the oven with such triumph that the very biscuits seemed to shine. “But not ordinary biscuits, my sweet one—these are enchanted. Each morsel bears a curious power, enough to confound your foes or strengthen your resolve. Yet beware! Every bite nibbles away at your good sense, for these are not mortal biscuits.” Alice gazed at the tray, then gave a small shrug of her shoulders. “Well, it can hardly be worse than it already is…” she murmured. And with that, she gathered the biscuits into her satchel, made a polite curtsey, and set off once more into Wonderland.",
]
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
	#var narratorTextPath: String = "res://Levels/StoryMode/PageText/page" + str(currentPage) + ".txt"
	label.text = text1[currentPage-1]

	#change image
	var imagePath: String = "res://Levels/StoryMode/Image/image" + str(currentPage) + ".png"
	image.texture = load(imagePath)
