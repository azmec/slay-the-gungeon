extends Control

onready var bossName = $HBoxContainer/VBoxContainer/BossName 
onready var healthBar = $HBoxContainer/VBoxContainer/HealthBar

func set_boss(new_name: String, healthStats: Node) -> void:
	bossName.text = new_name 
	healthBar.set_values(0, healthStats.max_health, healthStats.health)
	healthStats.connect("health_value_changed", self, "_on_healthStats_health_value_changed") 

func _on_healthStats_health_value_changed(new_value: int) -> void:
	healthBar.update_bar(new_value)