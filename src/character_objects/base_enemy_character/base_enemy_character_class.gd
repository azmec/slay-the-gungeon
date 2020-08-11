extends CharacterBody
class_name EnemyBody 

# Base enemy class that inherits from the base character. 
# Adds some common behaivor and nodes for all enemies to use,
# while keeping the declaration of which out of the way. 

const TEXT_POPUP = preload("res://src/compositional_objects/text_popup/text_popup.tscn")

var do_soft_collisions: bool = true 

onready var softCollisionArea = $SoftCollision
onready var playerDetector = $PlayerDetector
onready var wanderController = $WanderController
onready var healthBar = $HealthBar

func _ready() -> void:
    healthBar.set_values(0, healthStats.max_health, healthStats.health)

func _physics_process(delta: float) -> void:
    if softCollisionArea.is_colliding() and do_soft_collisions:
        velocity += softCollisionArea.get_push_vector() * delta * 800 

func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void:
    var new_popup = TEXT_POPUP.instance()
    new_popup.set_parameters(str(damage), "damage") 
    get_parent().add_child(new_popup)
    new_popup.global_position = self.global_position
    ._on_damage_taken(damage, knockback, infliction)

func _on_health_value_changed(new_value: int) -> void:
    healthBar.update_bar(new_value)