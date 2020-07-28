extends Area2D

var player = null

func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")
	self.connect("body_exited", self, "_on_body_exited")

func can_see_player() -> bool:
	return player != null

func _on_body_entered(body: KinematicBody2D) -> void:
	player = body

func _on_body_exited(_body: KinematicBody2D) -> void:
	player = null