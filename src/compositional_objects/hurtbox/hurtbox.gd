extends Area2D

signal damage_taken(damage, knockback, infliction)

# Hurtbox area2D. Listens to hitbox layers and sends signal based
# upon them.

func _ready() -> void:
	self.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D) -> void: 
	var damage = area.damage
	var knockback = to_local(area.global_position).normalized() * -area.knockback_vector
	var infliction = area.status_infliction
	emit_signal("damage_taken", damage, knockback, infliction)