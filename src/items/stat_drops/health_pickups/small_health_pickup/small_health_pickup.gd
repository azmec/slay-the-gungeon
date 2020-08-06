class_name HealthPickup
extends KinematicProp

var heal: int = 3

func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void:
    ._on_damage_taken(damage, knockback, infliction)