class_name CharacterBody
extends KinematicBody2D

# Base character. All characters inherit from this in order 
# to give common behaivor, reactions, and traits. 
# Additionally, it declares some variables all characters 
# would have, keeping the actual declarations out of the way. 

signal character_died(position) 

enum statuses {
	NONE,
	FROZEN,
	BURNING,
	POISONED, 
} 

export var MAX_SPEED: int = 100
export var ACCELERATION: int = 800
export var FRICTION: int = 400 
export var BURN_RESISTANCE: int = 100
export var POISON_RESISTANCE: int = 100

const HIT_EFFECT = preload("res://src/compositional_objects/hit_effect/hit_effect.tscn")
const DEATH_EFFECT = preload("res://src/compositional_objects/enemy_death_explosion/enemy_death_explosion.tscn")
 
onready var sprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var hitbox = $Hitbox
onready var healthStats = $HealthStats 

var infliction: int = statuses.NONE 
var velocity: Vector2 = Vector2.ZERO 
var affected_by_status_inflictions: bool = true 
var can_take_damage: bool = true 
var can_die: bool = true


func _ready() -> void:
	hurtbox.connect("damage_taken", self, "_on_damage_taken")
	animationPlayer.connect("animation_finished", self, "_on_animation_finished")
	healthStats.connect("no_health", self, "_on_no_health") 

func _physics_process(delta: float) -> void: 
	_handle_status_inflictions(delta)

func get_health() -> int:
	return healthStats.health

func get_max_health() -> int:
	return healthStats.max_health 

func _handle_status_inflictions(delta: float) -> void:
	if not affected_by_status_inflictions: return
	
	match infliction:
		statuses.NONE:
			return 
		statuses.FROZEN:
			pass
		statuses.BURNING:
			# Burning logic. DOT determined by the object that initially burned the
			# character and the character's burn resistance. Furthermore, the 
			# status is contagious.
			pass 
		statuses.POISONED:
			# Poisoned logic. DOT determined by object's poison value and character's
			# poison resistance. 
			pass
	 
func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void: 
	if not can_take_damage: return
	healthStats.health = healthStats.health - damage
	velocity = knockback
	var hit_fx = HIT_EFFECT.instance()
	get_parent().add_child(hit_fx)
	hit_fx.global_position = self.global_position
	OS.delay_msec(15)
	if infliction == "none":
		return
	elif infliction == "freeze":
		self.infliction = statuses.FROZEN
	elif infliction == "burn":
		self.infliction = statuses.BURNING
	elif infliction == "poison":
		self.infliction = statuses.POISONED
	 
func _on_animation_finished(anim_name: String) -> void: 
	pass 

func _on_no_health() -> void:
	if not can_die: return
	var death_fx = DEATH_EFFECT.instance() 
	get_parent().add_child(death_fx) 
	death_fx.global_position = self.global_position 
	emit_signal("character_died", self.global_position) 
	self.call_deferred("free")

