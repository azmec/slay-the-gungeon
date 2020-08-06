extends KinematicProp

const CARD_DROP = preload("res://src/items/card_drop/card_drop.tscn")

var opened: bool = false

func _physics_process(delta: float) -> void:
	._physics_process(delta) 

func spawn_card_drop() -> void:
	var new_drop = CARD_DROP.instance()
	get_parent().add_child(new_drop) 
	new_drop.global_position = self.global_position
	opened = true 

func _on_playerDetector_body_entered(_body) -> void:
	if opened: return
	self.call_deferred("spawn_card_drop")
	
func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void:
    ._on_damage_taken(damage, knockback, infliction)