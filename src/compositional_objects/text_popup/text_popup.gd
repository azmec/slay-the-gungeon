extends Position2D

# Compositional TextPopup. When instanced, it must be given text 
# to display, color, and lifetime. Upon spawn, it will appear at 
# a given position and tween itself upwards and fading away. 

var text: String = "0" 
var velocity = Vector2.ZERO
var type: String = "" 

onready var displayText = $Label 
onready var tween = $Tween 

func set_parameters(new_text, new_type) -> void:
	text = new_text 
	type = new_type

func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_all_completed")
	displayText.text = text 
	match type:
		"damage":
			displayText.set("custom_colors/font_color", Color("b53636"))
	randomize() 

	velocity = Vector2(randi() % 41 - 20, 50)
	tween.interpolate_property(self, "scale", self.scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _process(delta: float) -> void:
	position -= velocity * delta

func _on_tween_all_completed() -> void:
	self.queue_free()
