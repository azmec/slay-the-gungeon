extends Position2D

# Base Spell Projectile. 

const MOVE_SPEED: int = 400
const DECAY_TIME: float = 10.0 

var move_direction: Vector2 = Vector2.ZERO

onready var timer = $Timer
onready var hitbox = $Hitbox
onready var worldHitbox = $WorldHitbox  

func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout")
	worldHitbox.connect("body_entered", self, "_on_worldHitbox_body_entered")
	hitbox.connect("area_entered", self, "_on_hitbox_area_entered") 

func _physics_process(delta: float) -> void:
	self.global_position += move_direction.normalized() * MOVE_SPEED * delta

func spawn(position: Vector2, direction: Vector2, damage: int, infliction: String) -> void:
	self.global_position = position
	self.rotation = direction.angle()
	move_direction = direction
	hitbox.damage = damage
	hitbox.status_infliction = infliction
	self.scale.x = 1 + (damage * .1)
	self.scale.y = 1 + (damage * .1)
	timer.start(DECAY_TIME)

func _on_worldHitbox_body_entered(_body: PhysicsBody2D) -> void:
	self.call_deferred("free")

func _on_timer_timeout() -> void:
	self.call_deferred("free")

func _on_hitbox_area_entered(_area: Area2D) -> void:
	self.call_deferred("free")