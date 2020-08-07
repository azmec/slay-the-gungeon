extends Control

# Standard death screen. 

onready var menuButton = $ButtonsContainer/MenuButton 
onready var restartButton = $ButtonsContainer/RestartButton 
onready var quitButton = $ButtonsContainer/QuitButton 

func _ready() -> void:
	menuButton.connect("pressed", self, "_on_menuButton_pressed") 
	restartButton.connect("pressed", self, "_on_restartButton_pressed") 
	quitButton.connect("pressed", self, "_on_quitButton_pressed") 

func _on_menuButton_pressed() -> void:
	get_tree().change_scene_to(load("res://src/screens/title/title_screen.tscn")) 

func _on_restartButton_pressed() -> void:
	get_tree().reload_current_scene() 

func _on_quitButton_pressed() -> void:
	get_tree().quit()