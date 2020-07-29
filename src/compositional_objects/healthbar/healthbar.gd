extends Control

export (OpenSimplexNoise) var noise
export (float, 0, 1) var trauma = 0.0 
export (float, 0, 1) var decay = 0.6 

export var maximum_x_offset = 150 
export var maximum_y_offset = 150 
export var maximum_rotation = 45  

var time: float = 0 

onready var healthSliver = $HealthSliver
onready var healthContainer = $HealthContainer
onready var numericDisplay = $NumericDisplay

func _process(delta: float) -> void:
	time += delta

	var shake = pow(trauma, 2)  
	self.rect_position.x = noise.get_noise_3d(time * 100, 0, 0) * maximum_x_offset * shake
	#self.rect_position.y = noise.get_noise_3d(0, time * 100, 0) * maximum_y_offset * shake 
	self.rect_rotation = noise.get_noise_3d(0, 0, time * 100) * maximum_rotation * shake 

	if trauma > 0:
		trauma = clamp(trauma - (delta * decay), 0, 1)
