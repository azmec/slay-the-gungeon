extends KinematicProp

const HEALTH_PICKUP = preload("res://src/items/stat_drops/health_pickups/small_health_pickup/small_health_pickup.tscn")

var opened: bool = false

func _physics_process(delta: float) -> void:
	._physics_process(delta) 

func spawn_card_drop() -> void:
	var new_drop = HEALTH_PICKUP.instance()
	get_parent().add_child(new_drop) 
	new_drop.global_position = self.global_position
	opened = true 

func _on_playerDetector_body_entered(_body) -> void:
	if opened: return
	self.call_deferred("spawn_card_drop")
	
func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void:
    ._on_damage_taken(damage, knockback, infliction)