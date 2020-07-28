extends KinematicBody2D

# Standard slime enemy. Will chase towards player if in 
# detection zone. Else, it will wander. 

enum {
	IDLE,
	WANDER,
	CHASE,
	STAGGER
}

const MAX_SPEED: int = 125
const ACCELERATION: int = 800
const FRICTION: int = 400
const HIT_EFFECT = preload("res://src/compositional_objects/hit_effect/hit_effect.tscn")
const DEATH_EFFECT = preload("res://src/compositional_objects/enemy_death_explosion/enemy_death_explosion.tscn")

var state: int = 0
var velocity: Vector2 = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var playerDetector = $PlayerDetector
onready var hurtbox = $Hurtbox
onready var healthStats = $HealthStats
onready var softCollisionArea = $SoftCollision

func _ready() -> void:
	hurtbox.connect("damage_taken", self, "_on_damage_taken")
	animationPlayer.connect("animation_finished", self, "_on_animation_finished")
	healthStats.connect("no_health", self, "_on_no_health")
	state = IDLE

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			idle(delta)
		WANDER:
			wander(delta) 
		CHASE: 
			chase(delta)
		STAGGER:
			stagger(delta)
	if softCollisionArea.is_colliding():
		velocity += softCollisionArea.get_push_vector() * delta * 800
	velocity = move_and_slide(velocity)

func idle(delta: float) -> void:
	animationPlayer.play("idle")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if playerDetector.can_see_player():
		state = CHASE

func wander(delta:float) -> void:
	# TODO
	pass

func chase(delta:float) -> void:
	if playerDetector.can_see_player():
		animationPlayer.play("move")
		var player = playerDetector.player
		var direction_to_player = self.global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta)
	else:
		state = IDLE
	
func stagger(delta:float) -> void:
	animationPlayer.play("hurt")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func _on_damage_taken(damage: int, knockback: Vector2) -> void:
	healthStats.health = healthStats.health - damage
	velocity = knockback
	var hit_fx = HIT_EFFECT.instance()
	get_parent().add_child(hit_fx)
	hit_fx.global_position = self.global_position
	state = STAGGER

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "hurt":
		state = IDLE

func _on_no_health() -> void:
	var death_fx = DEATH_EFFECT.instance()
	get_parent().add_child(death_fx)
	death_fx.global_position = self.global_position
	self.call_deferred("free")