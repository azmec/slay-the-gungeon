extends Control

# Scuffed title screen for now. 

onready var newGame = $TitleScreen/NewGame 
onready var options = $TitleScreen/Options
onready var quit = $TitleScreen/Quit

onready var optionsScreen = $OptionsScreen 
onready var titleScreen = $TitleScreen

func _ready() -> void:
	newGame.connect("pressed", self, "_on_newGame_pressed") 
	options.connect("pressed", self, "_on_options_pressed")
	quit.connect("pressed", self, "_on_quit_pressed")
	optionsScreen.connect("backButton_pressed", self, "_on_optionsScreen_backButton_pressed")
	BGMController.play_new_track("res://assets/bgm/musIntro.ogg")


func _on_newGame_pressed() -> void:
	get_tree().change_scene_to(preload("res://src/prototype_world/prototype_world.tscn"))

func _on_options_pressed() -> void: 
	optionsScreen.visible = true
	titleScreen.visible = false
	
func _on_optionsScreen_backButton_pressed() -> void:
	titleScreen.visible = true 
	optionsScreen.visible = false
func _on_quit_pressed() -> void:
	get_tree().quit()
