extends Control

# Scuffed title screen for now. 

onready var newGame = $NewGame 
onready var options = $Options
onready var quit = $Quit
func _ready() -> void:
	newGame.connect("pressed", self, "_on_newGame_pressed") 
	options.connect("pressed", self, "_on_options_pressed")
	quit.connect("pressed", self, "_on_quit_pressed")

func _on_newGame_pressed() -> void:
	get_tree().change_scene_to(preload("res://src/prototype_world/prototype_world.tscn"))

func _on_options_pressed() -> void: 
	get_tree().change_scene_to(preload("res://src/prototype_world/prototype_world.tscn")) 

func _on_quit_pressed() -> void:
	get_tree().quit()
