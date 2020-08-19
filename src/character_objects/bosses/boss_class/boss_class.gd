class_name BossBody 
extends CharacterBody 

# The standard boss will always have the following:
# 1. A giant healthbar occupying the top portion of the screen.
# 2. A player detector to choose when to display this health bar. 
# 3. The property of destroying tiles. 
# 4. The ability to drop loop on death. 

signal player_entered_boss_radius(boss) 
signal player_left_boss_radius(boss)

var boss_name: String = "BOSS"
onready var playerDetector = $PlayerDetector
onready var waitTimer = $WaitTimer

func _ready() -> void:
	playerDetector.connect("body_entered", self, "_on_playerDetector_body_entered") 
	playerDetector.connect("body_exited", self, "_on_playerDetector_body_exited")
	waitTimer.connect("timeout", self, "_on_waitTimer_timeout")
	var world = get_node("/root/World") 
	self.connect("player_entered_boss_radius", world, "_on_BossBody_player_entered_boss_radius") 
	self.connect("player_left_boss_radius", world, "_on_BossBody_player_left_boss_radius")

func _on_playerDetector_body_entered(_body: Player) -> void:
	emit_signal("player_entered_boss_radius", self) 

func _on_playerDetector_body_exited(_body: Player) -> void:
	emit_signal("player_left_boss_radius") 

func _on_waitTimer_timeout() -> void:
	pass