extends Control 

# A modification of GameEndeavor's Health Bar. Here, it is set up so anything can inform 
# the node of a new health value. What informed it is what calls the update_bar function.
# This keeps us from setting up too much signal work just for a health bar.

onready var healthText = $HealthText
onready var healthBar = $HealthBar 
onready var progressBar = $ProgressBar
onready var updateTween = $UpdateTween 

# Called once on the character's "_ready()" function.
func set_values(minimum_value: float, maximum_value: float, current_value: float) -> void:
	healthBar.min_value = minimum_value
	healthBar.max_value = maximum_value 
	healthBar.value = current_value
	progressBar.min_value = minimum_value 
	progressBar.max_value = maximum_value 
	progressBar.value = current_value
	healthText.text = str(current_value) + "/" + str(maximum_value)

# Called whenever the character pleases. Most likely, "_on_health_value_changed"
func update_bar(new_value) -> void:
	updateTween.interpolate_property(progressBar, "value", progressBar.value, new_value, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT) 
	updateTween.start()
	healthBar.value = new_value
	healthText.text = str(new_value) + "/" + str(healthBar.max_value)
	