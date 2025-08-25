extends Node2D
const CARD_DRAW_SPEED = 0.4
const CARD_SCENE_PATH = "res://Cards/Card.tscn"
var player_deck: Array[CardResource] = GC.runDeck
@onready var player_hands: Node2D = $"../PlayerHands"
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rich_text_label: RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rich_text_label.text = str(player_deck.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_card():
	print("draw card")
	var card_drawn: CardResource = player_deck[0]
	player_deck.erase(card_drawn)
	if player_deck.size() == 0:
		collision_shape_2d.disabled = true
		sprite_2d.visible = false
		rich_text_label.visible = false
	rich_text_label.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)

	var new_card = card_scene.instantiate()
	new_card.cardResource = card_drawn
	# connect card action to Level1, Level1 is the grandparent of deck
	new_card.connect("apply_card_action", Callable(get_parent().get_parent(), "applay_card_effect"))
	$"../Cards".add_child(new_card)
	player_hands.add_card_to_hand(new_card, CARD_DRAW_SPEED)
