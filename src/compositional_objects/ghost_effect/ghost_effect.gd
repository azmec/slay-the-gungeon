extends Sprite

onready var ghostTween = $Tween

func _ready():
	ghostTween.connect("tween_completed", self, "_on_ghostTween_completed")
	ghostTween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6, Tween.TRANS_SINE, Tween.EASE_OUT)
	ghostTween.start()

func _on_ghostTween_completed(_object, _key) -> void:
	self.queue_free()
