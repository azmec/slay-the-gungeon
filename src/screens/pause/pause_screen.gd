extends Control

# Pause menu; meant to be overlayed ontop of the main game. 

onready var mainMenuButton = $InitialMenu/VBoxContainer/MainMenu
onready var restartButton = $InitialMenu/VBoxContainer/Restart
onready var quitButton = $InitialMenu/VBoxContainer/Quit
onready var optionsButton = $InitialMenu/VBoxContainer/Options
onready var resumeButton = $InitialMenu/VBoxContainer/Resume

onready var initialMenu = $InitialMenu
onready var optionsScreen = $OptionsScreen

onready var sceneTree = get_tree() 

var paused: bool = false setget set_paused
func _ready():
	mainMenuButton.connect("pressed", self, "_on_mainMenuButton_pressed")
	restartButton.connect("pressed", self, "_on_restartButton_pressed") 
	quitButton.connect("pressed", self, "_on_quitButton_pressed") 
	resumeButton.connect("pressed", self, "_on_resumeButton_pressed")
	optionsButton.connect("pressed", self, "_on_optionsButton_pressed")
	optionsScreen.connect("backButton_pressed", self, "_on_optionsScreen_backButton_pressed")

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
	sceneTree.paused = false

func _on_restartButton_pressed() -> void:
	get_tree().reload_current_scene() 
	sceneTree.paused = false

func _on_resumeButton_pressed() -> void: 
	self.paused = not paused 

func _on_optionsButton_pressed() -> void:
	initialMenu.visible = false
	optionsScreen.visible = true 

func _on_optionsScreen_backButton_pressed() -> void:
	optionsScreen.visible = false
	initialMenu.visible = true

func _on_quitButton_pressed() -> void:
	get_tree().quit()
