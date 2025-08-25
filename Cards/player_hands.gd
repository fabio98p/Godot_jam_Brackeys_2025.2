extends Node2D

const CARD_SCENE_PATH = "res://Cards/Card.tscn"
const CARD_WIDTH = 120
const HAND_Y_POSITION = 626
const DEFAULT_CARD_SPEED = 0.1

var player_hand: Array = []
var center_screen_x: float

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

func add_card_to_hand(card: Node2D, speed: float = DEFAULT_CARD_SPEED) -> void:
	if card in player_hand:
		# Se la carta è già in mano
		animate_card_to_position(card, card.starting_position, DEFAULT_CARD_SPEED)
	else:
		player_hand.insert(0, card)
		update_hand_position(speed)

func remove_card_from_hand(card: Node2D) -> void:
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position(DEFAULT_CARD_SPEED)

func update_hand_position(speed: float) -> void:
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position, speed)

func calculate_card_position(index: int) -> float:
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	return center_screen_x + index * CARD_WIDTH - total_width / 2

func animate_card_to_position(card: Node2D, new_position: Vector2, speed: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
