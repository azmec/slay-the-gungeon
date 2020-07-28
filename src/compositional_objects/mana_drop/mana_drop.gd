extends Node2D

func _ready() -> void:
	$Area2D.connect("body_entered", self, "_on_area2D_body_entered")

func _on_area2D_body_entered(body) -> void:
	body.mana += 1
	body._on_draw_button_pressed()
	self.queue_free()