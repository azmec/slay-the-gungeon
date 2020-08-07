class_name KinematicProp
extends KinematicBody2D

const MAX_SPEED = 800
const ACCELERATION = 800
const FRICTION = 400 

var velocity: Vector2 = Vector2.ZERO
var handle_z_index: bool = true 

onready var hurtbox = $Hurtbox
onready var playerDetector = $PlayerDetector

func _ready() -> void:
	hurtbox.connect("damage_taken", self, "_on_damage_taken") 
	playerDetector.connect("body_entered", self, "_on_playerDetector_body_entered")
	add_to_group("props")

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)  
	_handle_z_indexing()
	
func _handle_z_indexing() -> void:
	if handle_z_index:
		if playerDetector.can_see_player():
			var player = playerDetector.player
			if player.global_position.y < self.global_position.y:
				self.z_index = player.z_index + 1
			else:
				self.z_index = player.z_index - 1

func _on_damage_taken(_damage: int, knockback: Vector2, _infliction: String) -> void:
	velocity = knockback 
	
func _on_playerDetector_body_entered(_body) -> void:
	pass
