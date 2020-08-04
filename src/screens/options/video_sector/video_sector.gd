extends Control

# Video sector for options. Controls things like if the game 
# is fullscreen or its resolution. 

onready var resolutionDropdown = $ResolutionOption 
onready var fullscreenCheck = $FullscreenCheck 

var selected_resolution: Vector2 = Vector2(1280, 720) 

func _ready():
	resolutionDropdown.connect("item_selected", self, "_on_resolutionDropdown_item_selected")
	fullscreenCheck.connect("toggled", self, "_on_fullscreenCheck_toggled") 
	var i = 0
	for option in resolutionDropdown.new_options:
		if option == Options.resolution:
			resolutionDropdown.selected = i
			break
		else:
			i += 1

func _on_resolutionDropdown_item_selected(item_index: int) -> void:
	Options.resolution = resolutionDropdown.new_options[item_index] 


func _on_fullscreenCheck_toggled(checkbox_filled: bool) -> void:
	OS.window_fullscreen = checkbox_filled

