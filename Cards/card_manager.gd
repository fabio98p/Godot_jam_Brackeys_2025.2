extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_DROP_ZONE = 2
const DEFAULT_CARD_SPEED= 0.1
var screen_size
var card
var card_being_dragged
var is_hovering_on_card
var drag_offset = Vector2.ZERO
@export var scaleX: float
@export var scaleY: float
@onready var player_hand_reference: Node2D = $PlayerHands
@onready var input_manager: Node2D = $InputManager

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#card = raycast_check_for_card()
			#if card: 
				#start_drag(card)
		#else:
			#if card_being_dragged: 
				#finish_drag()


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)



func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)

func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(scaleX,scaleY)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_card_with_highest_z_index(result)
	return null

func raycast_check_for_card_drop_zone():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_DROP_ZONE
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return result[0].collider.get_parent()
	return null


func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	drag_offset = card.global_position - get_global_mouse_position()
func finish_drag():
	card_being_dragged.scale = Vector2(scaleX, scaleY)
	var drop_zone_found = raycast_check_for_card_drop_zone()
	if drop_zone_found and not drop_zone_found.card_in_drop_zone:
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.position = drop_zone_found.position
		#print(card_being_dragged.get_node("Area2D/CollisionShape2D"))
		card_being_dragged.cardDataHandler.playCard("playCard")
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		drop_zone_found.card_in_drop_zone = true
		toggle_drop_zone(drop_zone_found, card_being_dragged)
		#card_being_dragged.destroy_card()
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_SPEED)
	card_being_dragged = null

func toggle_drop_zone(drop_zone_found, card_being_dragged):
	await get_tree().create_timer(4).timeout
	drop_zone_found.card_in_drop_zone = false
	card_being_dragged.destroy_card()


func on_left_click_release():
	if card_being_dragged: 
		finish_drag()

# Called when the node enters the scene tree for the first time. 
func _ready() -> void:
	screen_size = get_viewport_rect().size
	input_manager.connect("left_mouse_button_release", on_left_click_release)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = Vector2(
			clamp(mouse_pos.x + drag_offset.x, 0, screen_size.x),
			clamp(mouse_pos.y + drag_offset.y, 0, screen_size.y)
		)
