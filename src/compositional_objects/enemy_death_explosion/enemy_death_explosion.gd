extends AnimatedSprite

func _ready() -> void:
	self.connect("animation_finished", self, "_on_animation_finished")
	self.play("death_explosion")

func _on_animation_finished() -> void: 
	self.call_deferred("free")