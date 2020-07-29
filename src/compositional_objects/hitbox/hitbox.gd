extends Area2D

# A hitbox area2D. Does not do anything by itself; interactions 
# handled by hurtboxes. 

export var damage: int = 1
export var knockback_vector: Vector2 = Vector2(0, 0) 

var status_infliction: String = "none"

onready var collisionShape = $CollisionShape2D