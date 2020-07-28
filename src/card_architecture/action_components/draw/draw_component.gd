extends Node

# Card draw component. 

var amount: int = 0
var deck: CardDatabase 
var hand: CardDatabase

func load_arguments(draw_component: Dictionary) -> void:
	amount = draw_component["amount"] 
	deck = draw_component["deck"]
	hand = draw_component["hand"]

# TODO: Hand doesn't play draw animation. Should be fixed.
func play() -> void:
	for card in amount:
		if deck.count() == 0: return
		else:
			var new_draw = deck.draw_card()
			hand.add_card(new_draw)
