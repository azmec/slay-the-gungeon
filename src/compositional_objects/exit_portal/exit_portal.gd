extends Node2D

# A portal that spawns upon the player killing all enemies in a level,
# like Nuclear Throne. The player must walk atop it, upon which it will send
# a signal to whatever main game node there is generate a new level. 

signal player_entered()

onready var animationPlayer = $AnimationPlayer
onready var playerDetector = $PlayerDetector 

func _ready() -> void:
	playerDetector.connect("body_entered", self, "_on_playerDetector_body_entered") 

func _on_playerDetector_body_entered(_body: Player) -> void:
	emit_signal("player_entered")