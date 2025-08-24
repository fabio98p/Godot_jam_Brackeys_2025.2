extends Node2D
#SCRIPT DEL CARDMANAGER

const HAND_COUNT = 5
const CARD_SCENE_PATH = "res://Cards/Card.tscn"
const CARD_WIDTH = 120
const HAND_Y_POSITION = 626
var player_hand = []
var center_screen_x
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../Cards".add_child(new_card)
		add_card_to_hand(new_card)

func add_card_to_hand(card):
	player_hand.insert(0, card)
	update_hand_position()

func update_hand_position():
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position)

func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func is_in_hand_zone(pos: Vector2) -> bool:
	var screen_size = get_viewport().size
	var hand_rect = Rect2(Vector2(screen_size.x * 0.25, HAND_Y_POSITION - 50),
						  Vector2(screen_size.x * 0.5, 100)) # rettangolo al centro
	return hand_rect.has_point(pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
