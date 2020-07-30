extends Control

# Video sector for options. Controls things like if the game 
# is fullscreen or its resolution. 

onready var resolutionDropdown = $ResolutionOption 
onready var fullscreenCheck = $FullscreenCheck 

var selected_resolution: Vector2 = Vector2(1280, 720) 

func _ready():
	resolutionDropdown.connect("item_selected", self, "_on_resolutionDropdown_item_selected")
	fullscreenCheck.connect("toggled", self, "_on_fullscreenCheck_toggled") 
	resolutionDropdown.selected = 1

func _on_resolutionDropdown_item_selected(item_index: int) -> void:
	if item_index == 0:
		OS.set_window_size(Vector2(1920, 1080))
	elif item_index == 1:
		OS.set_window_size(Vector2(1280, 720))
	elif item_index == 2:
		OS.set_window_size(Vector2(320, 180))
		
	selected_resolution = OS.get_window_size()
	OS.set_window_position((OS.get_screen_size() * 0.5) - (OS.get_window_size() * 0.5))

func _on_fullscreenCheck_toggled(checkbox_filled: bool) -> void:
	OS.window_fullscreen = checkbox_filled

