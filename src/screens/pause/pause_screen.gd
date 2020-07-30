extends Control

# Pause menu; meant to be overlayed ontop of the main game. 

onready var mainMenuButton = $VBoxContainer/MainMenu
onready var restartButton = $VBoxContainer/Restart 
onready var quitButton = $VBoxContainer/Quit 

onready var sceneTree = get_tree() 

var paused: bool = false setget set_paused
func _ready():
	mainMenuButton.connect("pressed", self, "_on_mainMenuButton_pressed")
	restartButton.connect("pressed", self, "_on_restartButton_pressed") 
	quitButton.connect("pressed", self, "_on_quitButton_pressed") 

func set_paused(value: bool) -> void: 
	paused = value 
	sceneTree.paused = value
	self.visible = value

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused 
		sceneTree.set_input_as_handled() 
	
func _on_mainMenuButton_pressed() -> void:
	get_tree().change_scene_to(load("res://src/screens/title/title_screen.tscn"))

func _on_restartButton_pressed() -> void:
	get_tree().reload_current_scene() 
	sceneTree.paused = false

func _on_quitButton_pressed() -> void:
	get_tree().quit()
