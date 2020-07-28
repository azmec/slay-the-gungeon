extends Node2D

const MOVE_SPEED: int = 200
const DECAY_TIME: float = 10.0

var move_direction: Vector2 = Vector2.ZERO

onready var timer = $Timer
onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var worldHitbox = $WorldHitbox 

func _ready():
    timer.connect("timeout", self, "_on_timer_timeout")
    hitbox.connect("area_entered", self, "_on_area_entered")
    worldHitbox.connect("body_entered", self, "_on_worldHitbox_body_entered")
    
func _physics_process(delta: float) -> void:
    self.global_position += move_direction.normalized() * MOVE_SPEED * delta

func spawn(position: Vector2, direction: Vector2) -> void: 
    self.global_position = position
    direction += Vector2((rand_range(-1, 1)), (rand_range(-1, 1))) * direction
    self.rotation = direction.angle() 
    move_direction = direction
    timer.start(DECAY_TIME) 

func _on_area_entered(_area: Area2D) -> void: 
    self.queue_free() 

func _on_worldHitbox_body_entered(_body: PhysicsBody2D) -> void:
    self.queue_free() 

func _on_timer_timeout() -> void:
    self.queue_free()