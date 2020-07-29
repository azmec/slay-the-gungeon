extends Node2D

var radius: int = 0 
var status_infliction: String

onready var sprite = $Sprite
onready var tween = $Tween
onready var hitbox = $Hitbox

func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_completed") 

func spawn(position: Vector2, hitbox_radius: int, amount: int, infliction: String) -> void:
	hitbox.damage = amount
	hitbox.status_infliction = infliction
	self.global_position = position 
	radius = hitbox_radius 
	tween.interpolate_property(sprite, "scale", sprite.scale, Vector2(radius, radius), 0.2, Tween.EASE_IN, Tween.EASE_OUT) 
	tween.interpolate_property(hitbox.collisionShape.shape, "radius", hitbox.collisionShape.shape.radius, 10 * radius, 0.2, Tween.EASE_IN, Tween.EASE_OUT)
	tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2, Tween.EASE_IN, Tween.EASE_OUT)
	tween.start()

func _on_tween_completed() -> void:
	self.queue_free()
