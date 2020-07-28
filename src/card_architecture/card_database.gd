extends Node
class_name CardDatabase

# Intended to be use as any kind of "CardDatabase": deck, graveyard, library, etc.

signal size_changed(new_size)
signal card_added(card)
signal multiple_cards_added(cards)
signal card_removed(card) 

var database_name: String = "" 

var _cards: Dictionary = {}

func _init(name: String) -> void:
	self.name = name

func count() -> int:
	return _cards.size()

func cards() -> Array:
	return _cards.keys()

# We can't have duplicate card values due to the nature 
# of dictionaries, so we techincally can't have duplicate cards. 
# Right now, we've set CardData.id to be a string version of 
# the particular card key of CardLibrary.DATA. Therefore, we 
# can just add anything to the end of that string and have it
# count as a different card.  

# In adding the discard button, card names are being altered,
# resulting in invalid get indexes. Must be fixed.
func add_card(card: CardData) -> void:
	_cards[card.card_name] = card 

	emit_signal("card_added", card)
	emit_signal("size_changed", count())

func add_multiple_cards(card_array: Array) -> void:
	for card in card_array:
		if card != null and card is CardData:
			if card_exists(card.card_name):
				card.card_name = str(card.card_name) + str(_cards.size())
			_cards[card.card_name] = card 

	emit_signal("multiple_cards_added", card_array)
	emit_signal("size_changed", count())

func card_exists(name: String) -> bool:
	return _cards.has(name)

# TODO: Should take CardData and remove based on that.
func get_card(name: String) -> CardData:
	if _cards.has(name):
		return _cards[name]
	else:
		return null


func remove_card(name: String) -> void:
	var card = _cards[name]
	_cards.erase(name)
	
	emit_signal("size_changed", count())
	emit_signal("card_removed", card)

func get_random_card() -> CardData:
	var library_keys = _cards.keys()
	var random_card = _cards[library_keys[randi() % library_keys.size()]]
	return random_card

func draw_card() -> CardData:
	var new_draw = get_random_card()
	remove_card(new_draw.card_name)
	return new_draw 

func clear() -> void:
	for card in _cards.keys():
		var given_card = _cards[card]
		remove_card(given_card.card_name)
