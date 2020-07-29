extends Node

# Radial Damage Component 

const RADIAL_EXPLOSION = preload("res://src/compositional_objects/radial_explosion/radial_explosion.tscn")

var card_player
var amount: int = 0
var radius: int = 0
var status_infliction: String = "none"

func load_arguments(damage_component: Dictionary, owner) -> void:
	amount = damage_component["amount"]
	radius = damage_component["radius"]
	status_infliction = damage_component["status_infliction"] 
	print(status_infliction)
	card_player = owner 

func play() -> void:
	var explosion = RADIAL_EXPLOSION.instance()
	card_player.get_parent().add_child(explosion)
	explosion.spawn(card_player.global_position, radius, amount, status_infliction)
