extends CharacterBody
class_name EnemyBody 

# Base enemy class that inherits from the base character. 
# Adds some common behaivor and nodes for all enemies to use,
# while keeping the declaration of which out of the way. 

onready var softCollisionArea = $SoftCollision
onready var playerDetector = $PlayerDetector
onready var wanderController = $WanderController

func _physics_process(delta: float) -> void:
    if softCollisionArea.is_colliding():
        velocity += softCollisionArea.get_push_vector() * delta * 800 