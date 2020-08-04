extends Control
class_name HandWidget
# HandWidget class - Display cards like you have them in hand. 

const PLAYABLE_CARD = preload("res://src/card_architecture/card_default/card_default.tscn")
export var card_overlap: int = 30
export var vertical_offset: int = 20
export var card_angle: float = 3
export var mouse_hover_offset: Vector2 = Vector2(0, -25)
export var selected_vertical_offset: int = -50
export var draw_point: NodePath
export var discard_point: NodePath

var raised = false 

var _hand = null
var _deck = null
var _owner = null
var _focused_card = null
var _active_cards = Node2D.new()
var _discarded_cards = Node2D.new() 
var _raised_position: Vector2 = Vector2(16, 112)
var _lowered_position: Vector2 = Vector2(16, 192)
var _button_pressed

onready var raiseTween = $RaiseTween 
onready var playArea = $PlayArea

func _ready() -> void:
	add_child(_active_cards) 
	add_child(_discarded_cards)
	raised = false
 
func _process(delta) -> void:
	if _focused_card != null and _button_pressed:
		_focused_card.position = lerp(_focused_card.position, get_local_mouse_position(), 25 * delta)

func set_hand(hand_database: CardDatabase, deck_database: CardDatabase, owner) -> void:
	_hand = hand_database
	_hand.connect("card_added", self, "_on_hand_card_added")
	_hand.connect("multiple_cards_added", self, "_on_hand_multiple_cards_added")
	_hand.connect("card_removed", self, "_on_hand_card_removed")  

	_deck = deck_database
	_owner = owner

func set_focused_card(card: PlayableCard) -> void:
	if _focused_card != null: return
	_focused_card = card
	_focused_card.bring_to_front()
	_focused_card.push_animation_state(mouse_hover_offset, 0, Vector2(1, 1), true, false, true)
	#print(str(_focused_card))

func unset_focused_card(card: PlayableCard) -> void:
	if _focused_card != card: return
	_focused_card.pop_animation_state()
	_focused_card.reset_z_index()
	_focused_card = null

func set_selected_card(card: PlayableCard) -> void:
	if _focused_card != card: return 
	_focused_card._animation.stop_all()

func unset_selected_card(card: PlayableCard) -> void:
	if _focused_card != card: return 
	_focused_card.pop_animation_state()
	_focused_card._animation.start()
	#_apply_hand_transform()
	#_remove_playable_card(card.get_card_data())
	#_hand.remove_card(card.get_card_data().card_name)

func move_hand() -> void:
	if raised:
		raiseTween.interpolate_property(
			self, "rect_position", self.rect_position, _lowered_position, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
		)  
		raised = false
	else:
		raiseTween.interpolate_property(
			self, "rect_position", self.rect_position, _raised_position, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
		) 
		raised = true
	raiseTween.start()

func _add_playable_card(card_data: CardData) -> PlayableCard:
	var playable_card = PLAYABLE_CARD.instance()
	playable_card.initialize_card(card_data, _owner) 
	_active_cards.add_child(playable_card)

	playable_card.connect("mouse_entered", self, "_on_playable_card_mouse_entered", [playable_card])
	playable_card.connect("mouse_exited", self, "_on_playable_card_mouse_exited", [playable_card])
	playable_card.connect("mouse_pressed", self, "_on_playable_card_mouse_pressed", [playable_card])
	playable_card.connect("mouse_released", self, "_on_playable_card_mouse_released", [playable_card])

	return playable_card

# NOTE: If we're getting cards from a CardDatabase, CardData.card_name will be different
# based on if it's a duplicate and when it was appened to the database. Therefore, 
# we will check based on it's card_name
func _remove_playable_card(card: CardData) -> void:
	for playable_card in _active_cards.get_children():
		if playable_card.card_name == card.card_name:
			_active_cards.remove_child(playable_card)
			_discarded_cards.add_child(playable_card)
			if _apply_discard_transform(playable_card):
				yield(get_tree().create_timer(0.07), "timeout")
			_discarded_cards.remove_child(playable_card)
			playable_card.queue_free() 

func _apply_hand_transform() -> void:
	yield(get_tree(), "idle_frame")

	var card_index = 0
	var total_cards = _hand.count()
	var half_of_total = float(total_cards) / 2.0
	var final_card_overlap = card_overlap
	var playable_card = PLAYABLE_CARD.instance()

	# Size calculations of card. 
	var card_height = self.rect_size.y * 2
	var ratio = card_height / playable_card.default_size.y
	var size = Vector2(round(playable_card.default_size.x * ratio), card_height)

	# Overlap check. 
	var total_hand_width = (size.x - card_overlap) * total_cards 
	# If the hand is larger than the HandWidget, we recalculate an overlap to fit all the cards.
	if total_hand_width > rect_size.x: 
		final_card_overlap = ceil((size.x * total_cards - self.rect_size.x) / (total_cards - 1)) 

	for card in _active_cards.get_children():
		var middle = rect_size.x / 2 
		var distance = float(card_index) - half_of_total + 0.5
		var position = Vector2(middle + distance * (size.x - final_card_overlap), -vertical_offset + card_height / 2) 

		var rotation = card_angle * distance

		card.default_z_index = card_index
		card.push_animation_state(position, rotation, card.default_size, false, false, false)

		card_index += 1

func _apply_draw_transform(card: PlayableCard) -> bool:
	if !draw_point.is_empty():
		card.global_position = get_node(draw_point).global_position 
		card.rotation_degrees = 90
		card.scale = Vector2(0, 0)
		return true
	else: return false

func _apply_discard_transform(card) -> bool:
	if !discard_point.is_empty():
		card.push_animation_state(_to_local(get_node(discard_point).global_position), 90, Vector2(0, 0))
		card.disconnect("mouse_entered", self, "_on_playable_card_mouse_entered")
		card.disconnect("mouse_exited", self, "_on_playable_card_mouse_exited")
		card.disconnect("mouse_pressed", self, "_on_playable_card_mouse_pressed")
		card.disconnect("mouse_released", self, "_on_playable_card_mouse_released")
		return true
	else:
		return false

# Node2D "to_local" rip because Control nodes don't have it.
func _to_local(point: Vector2) -> Vector2:
	return get_global_transform().affine_inverse().xform(point)

func _play_area_colliding() -> bool:
	return playArea.get_overlapping_areas().size() >= 1

func _on_hand_card_added(added_card: CardData) -> void:
	var card = _add_playable_card(added_card)
	_apply_draw_transform(card)
	_apply_hand_transform()

func _on_hand_multiple_cards_added(cards: Array) -> void:
	print("adding multiple cards")
	for card in cards:
		var new_card = _add_playable_card(card)
		_apply_draw_transform(new_card)
	#yield(get_tree().create_timer(0.1), "timeout")
	_apply_hand_transform()

func _on_hand_card_removed(card: CardData) -> void:
	_remove_playable_card(card)                                    
	_apply_hand_transform()

func _on_playable_card_mouse_entered(card: PlayableCard) -> void:
	#print(str(card.card_name), " is focused!")
	set_focused_card(card)

func _on_playable_card_mouse_exited(card: PlayableCard) -> void:
	#print(str(card.card_name), " is no longer focused!")
	unset_focused_card(card)

func _on_playable_card_mouse_pressed(button, card: PlayableCard) -> void:
	if button == BUTTON_LEFT:
		_button_pressed = true
		#print(str(card.card_name), " is selected!")
		set_selected_card(card)

func _on_playable_card_mouse_released(button, card: PlayableCard) -> void:
	if button == BUTTON_LEFT:
		if _play_area_colliding() and card.cost <= _owner.mana: 
			card.play_card()
			_owner.mana -= card.cost
			card.pop_animation_state()
			_deck.add_card(card.get_card_data())
			print(_deck.cards())
			print(card.text_name)
			_remove_playable_card(card.get_card_data())
			_hand.remove_card(card.get_card_data().card_name)
		else:
		#print(str(card.card_name), " is no longer selected!")
			unset_selected_card(card) 
		_button_pressed = false
