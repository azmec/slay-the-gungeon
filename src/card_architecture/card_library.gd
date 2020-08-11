extends Node

const STARTER_DECK = {
	"Alpha_001": {
		"attributes": {
			"name": "Rejection",
			"type": "Attack",
			"cost": 2,
			"desc": "Deal 1 damage and push away all enemies in a radius.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/frost_nova.png"
		},
		"components": [
			{"action": "radial_damage", "args": {"amount": 1, "radius": 6, "status_infliction": "freeze"}}
		]
	},
	"Alpha_002": {
		"attributes": {
			"name": "Strike",
			"type": "Attack",
			"cost": 1,
			"desc": "Deal 3 damage to an enemy.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/arcane_breath.png"
		},
		"components": [
			{"action": "damage", "args": {"targets": 1, "amount": 3, "status_infliction": "none"}}
		]
	},
}
const DATA = {
	"Alpha_000": {
		"attributes": {
			"name": "Visionary",
			"type": "Spell",
			"cost": 3,
			"desc": "Draw 2 cards.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/arcane_intellect.png"
		},
		
		"components": [
			{"action": "draw", "args": {"amount": 2, "deck": CardDatabase, "hand": CardDatabase}}
		]
	},
	"Alpha_003": {
		"attributes": {
			"name": "Consecrate",
			"type": "Attack",
			"cost": 3,
			"desc": "Deal 4 damage in a radius." ,
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/arcane_explosion.png"
		},
		"components": [
			{"action": "radial_damage", "args": {"amount": 4, "radius": 6, "status_infliction": "none"}}
		]
	},
	"Alpha_004": {
		"attributes": {
			"name": "Parry",
			"type": "Attack",
			"cost": 2,
			"desc": "Deal 1 damage and draw a card.", 
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/arcane_explosion.png"
		},
		"components": [
			{"action": "damage", "args": {"targets": 1, "amount": 1, "status_infliction": "none"}},
			{"action": "draw", "args": {"amount": 1, "deck": CardDatabase, "hand": CardDatabase}}
		]
	}
}

func draft_player_deck() -> CardDatabase:
	var player_deck = CardDatabase.new("player_deck") 
	for i in 5:
		var new_card = CardData.new(STARTER_DECK["Alpha_002"])
		player_deck.add_card(new_card)
	for i in 5:
		var new_card = CardData.new(STARTER_DECK["Alpha_001"])
		player_deck.add_card(new_card)
	
	for i in 2:
		var new_card = CardData.new(get_random_card_index())
		player_deck.add_card(new_card)
	return player_deck

func get_random_card_index() -> Dictionary:
	var data_keys = DATA.values()
	var random_card_index = data_keys[randi() % DATA.size()]
	return random_card_index
