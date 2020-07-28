extends Node

const DATA = {
	"Indev_000": {
		"attributes": {
			"name": "Arcane Intellect",
			"type": "Spell",
			"cost": 3,
			"desc": "Draw 2 cards.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/arcane_intellect.png"
		},
		
		"components": [
			{"action": "draw", "args": {"amount": 2, "deck": CardDatabase, "hand": CardDatabase}}
		]
	},
	"Indev_001": {
		"attributes": {
			"name": "Frost Nova",
			"type": "Attack",
			"cost": 3,
			"desc": "Freeze all enemies in a radius.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/frost_nova.png"
		},
		"components": [
			{"action": "radial_damage", "args": {"amount": 0, "radius": 6, "status_infliction": "freeze"}}
		]
	},
	"Indev_002": {
		"attributes": {
			"name": "Arcane Breath",
			"type": "Attack",
			"cost": 1,
			"desc": "Deal 2 damage to an enemy. Discover a card.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/arcane_breath.png"
		},
		"components": [
			{"action": "damage", "args": {"targets": 1, "amount": 2, "status_infliction": "none"}},
			{"action": "discover"}
		]
	},
	"Indev_003": {
		"attributes": {
			"name": "Arcane Explosion",
			"type": "Attack",
			"cost": 2,
			"desc": "Deal 1 damage in a radius." ,
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/arcane_explosion.png"
		},
		"components": [
			{"action": "radial_damage", "args": {"amount": 1, "radius": 6, "status_infliction": "none"}}
		]

	},
	"Index_004": {
		"attributes": {
			"name": "Frostbolt",
			"type": "Attack",
			"cost": 2,
			"desc": "Deal 3 damage to an enemy and Freeze it.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/frostbolt.png"
		},
		"components": [
			{"action": "damage", "args": {"targets": 1, "amount": 3, "status_infliction": "freeze"}}
		]
	},
	"Index_005": {
		"attributes": {
			"name": "Fireball",
			"type": "Attack",
			"cost": 4,
			"desc": "Deal 6 damage to an enemy.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/fireball.png"
		},
		"components": [
			{"action": "damage", "args": {"targets": 1, "amount": 6, "status_infliction": "none"}}
		]
	},
	"Index_006": {
		"attributes": {
			"name": "Flamestrike",
			"type": "Attack", 
			"cost": 7, 
			"desc": "Deal 4 damage in a radius.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/flame_strike.png"
		},
		"components": [
			{"action": "radial_damage", "args": {"amount": 4, "radius": 10, "status_infliction": "none"}}
		]
	},
	"Index_007": {
		"attributes": {
			"name": "Blizzard", 
			"type": "Attack", 
			"cost": 6,
			"desc": "Deal 2 damage and Freeze in a radius.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/blizzard.png"
		},
		"components": [
			{"action": "radial_damage", "args": {"amount": 2, "radius": 8, "status_infliction": "freeze"}},
		]
	},
	"Index_008": {
		"attributes": {
			"name": "Pyroblast",
			"type": "Attack",
			"cost": 10,
			"desc": "Deal 10 damage to an enemy.",
			"sprite_path": "res://assets/sprites/cards/hearthstone_cards/mage/pyroblast.png"
		},
		"components": [
			{"action": "damage", "args": {"targets": 1, "amount": 10, "status_infliction": "none"}}
		]
	}
}

func get_random_card_index() -> Dictionary:
	var data_keys = DATA.values()
	var random_card_index = data_keys[randi() % DATA.size()]
	return random_card_index