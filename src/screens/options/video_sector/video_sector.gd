extends Control

# Video sector for options. Controls things like if the game 
# is fullscreen or its resolution. 

onready var languageDropdown = $Buttons/LanguageOptions
onready var resolutionDropdown = $Buttons/ResolutionOption 
onready var fullscreenCheck = $Checks/FullscreenCheck 

var selected_resolution: Vector2 = Vector2(1280, 720) 

func _ready():
	languageDropdown.connect("item_selected", self, "_on_languageDropdown_item_selected")
	resolutionDropdown.connect("item_selected", self, "_on_resolutionDropdown_item_selected")
	fullscreenCheck.connect("toggled", self, "_on_fullscreenCheck_toggled") 
	load_resolution()
	load_language()
	

func load_resolution() -> void:
	var i = 0
	for option in resolutionDropdown.new_options:
		if option == Options.resolution:
			resolutionDropdown.selected = i
			break
		else:
			i += 1  

func load_language() -> void:
	var i = 0 
	for option in languageDropdown.new_options:
		if option == Options.language:
			languageDropdown.selected = i 
			break 
		else: 
			i += 1

func _on_languageDropdown_item_selected(item_index: int) -> void: 
	Options.language = languageDropdown.new_options[item_index]

func _on_resolutionDropdown_item_selected(item_index: int) -> void:
	Options.resolution = resolutionDropdown.new_options[item_index] 


func _on_fullscreenCheck_toggled(checkbox_filled: bool) -> void:
	OS.window_fullscreen = checkbox_filled

