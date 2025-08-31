extends Node2D
const CARD_DRAW_SPEED = 0.4
const CARD_SCENE_PATH = "res://Cards/Card.tscn"
var player_deck: Array[CardResource]
@onready var player_hands: Node2D = $"../PlayerHands"
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rich_text_label: RichTextLabel = $RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	runDeckDuplicator()
	#rich_text_label.text = str(player_deck.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GC.new_turn:
		await get_tree().create_timer(1).timeout
		if GC.cards_drawn_this_turn <= 2:
			draw_card()
			GC.cards_drawn_this_turn += 1
		else:
			GC.new_turn=false


func draw_card():
	if player_hands.player_hand.size() <= 6:
		# Scelgo un indice casuale dal mazzo
		var random_index: int = randi() % player_deck.size()
		# Pesco la carta usando l'indice casuale
		var card_drawn: CardResource = player_deck[random_index]
		# Rimuovo la carta pescata dal mazzo
		player_deck.remove_at(random_index)
		if player_deck.size() == 0:
			runDeckDuplicator()
			#collision_shape_2d.disabled = true
			#sprite_2d.visible = false
			#rich_text_label.visible = false
		#rich_text_label.text = str(player_deck.size())
		var card_scene = preload(CARD_SCENE_PATH)

		var new_card = card_scene.instantiate()
		new_card.cardResource = card_drawn
		# connect card action to Level1, Level1 is the grandparent of deck
		new_card.connect("apply_card_action", Callable(get_parent().get_parent(), "applay_card_effect"))
		$"../Cards".add_child(new_card)
		player_hands.add_card_to_hand(new_card, CARD_DRAW_SPEED)
		Utils.play_sfx(Pools.GetCocky[randi_range(0,Pools.GetCocky.size()-1)], "SFX")

func runDeckDuplicator():
	player_deck = GC.runDeck.duplicate()
