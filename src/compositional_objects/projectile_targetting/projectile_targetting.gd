extends Node2D

const SPELL_PROJECTILE = preload("res://src/compositional_objects/spell_projectile/spell_projectile.tscn")
var direction_vector: Vector2
var damage: int = 0
var status_infliction: String = "none"
onready var mouseArea = $Control 
onready var targetter = get_parent()

func _ready():
	mouseArea.connect("gui_input", self, "_on_input_event") 

func _process(delta):
	self.global_position = get_global_mouse_position()
	direction_vector = targetter.global_position.direction_to(self.global_position) 

func load_projectile_arguments(amount: int, infliction: String) -> void:
	self.damage = amount
	self.status_infliction = infliction 

func _on_input_event(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		var new_projectile = SPELL_PROJECTILE.instance()
		targetter.get_parent().add_child(new_projectile)
		new_projectile.spawn(targetter.global_position, direction_vector, damage, status_infliction) 
		self.call_deferred("free")
