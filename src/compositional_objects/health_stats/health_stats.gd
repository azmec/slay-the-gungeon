extends Node

# A composition piece that contains and tracks health.

signal no_health() 

export var max_health: int = 100
onready var health: int = max_health setget set_health

func set_health(value: int) -> void:
	if value > max_health:
		health = max_health 
		return 
	health = value
	if health <= 0:
		emit_signal("no_health")
	
