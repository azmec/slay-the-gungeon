extends KinematicBody2D

export var MAX_SPEED: int = 200
export var ACCELERATION: int = 800
export var FRICTION: int = 400  

var velocity: Vector2 = Vector2.ZERO 

onready var softCollisionArea = $SoftCollision 
onready var playerDetector = $PlayerDetector

func _ready() -> void:
	$Area2D.connect("body_entered", self, "_on_area2D_body_entered")

func _physics_process(delta):
	if softCollisionArea.is_colliding():
		velocity += softCollisionArea.get_push_vector() * delta * 800  
	if playerDetector.can_see_player():
		var player = playerDetector.player
		var direction_to_player = self.global_position.direction_to(player.global_position)

		velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta) 
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 

	velocity = move_and_slide(velocity)
	
func _on_area2D_body_entered(body) -> void:
	body.mana += 1
	self.queue_free()