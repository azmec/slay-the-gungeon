extends Node

# Damage component.

const TARGETTER = preload("res://src/compositional_objects/projectile_targetting/projectile_targetting.tscn") 

var card_player
var targets: int = 0
var amount: int = 0
var status_infliction: String = "none"

func load_arguments(damage_component: Dictionary, owner) -> void:
	targets = damage_component["targets"] 
	amount = damage_component["amount"]
	status_infliction = damage_component["status_infliction"] 

	card_player = owner

func play() -> void:
	var reticle = TARGETTER.instance()
	reticle.load_projectile_arguments(amount, status_infliction)
	card_player.add_child(reticle)
