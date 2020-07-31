extends Control

# Global options are managed here. 
# Things like audio volume, controls, graphical options, etc. 
# For right now, we have default values. On release or any build,
# these should be changed to get the values of the config file, and
# then run that through the setget. 

# GRAPHICS
# ------------------------------------------------------------------

var resolution = Vector2(1280, 720) setget _set_screen_resolution
var is_fullscreen: bool = false setget _set_fullscreen
# AUDIO 
# ------------------------------------------------------------------ 

var master_volume: float = 1 setget _set_master_volume
var bgm_volume: float = 1 setget _set_bgm_volume 
var sfx_volume: float = 1 setget _set_sfx_volume

# CONTROLS 
# ------------------------------------------------------------------ 


onready var masterBus: int = AudioServer.get_bus_index("Master")
onready var bgmBus: int = AudioServer.get_bus_index("BGM") 
onready var sfxBus: int = AudioServer.get_bus_index("SFX") 


func _ready() -> void:
	load_settings_from_config() 

func load_settings_from_config() -> void:
	self.resolution = Vector2(Settings.get_setting("graphics", "vertical_resolution"),Settings.get_setting("graphics", "horizontal_resolution"))
	self.is_fullscreen = Settings.get_setting("graphics", "is_fullscreen")
	
	self.master_volume = Settings.get_setting("audio", "master_volume") 
	self.bgm_volume = Settings.get_setting("audio", "bgm_volume") 
	self.sfx_volume = Settings.get_setting("audio", "sfx_volume") 


func _set_screen_resolution(new_resolution: Vector2) -> void:
	resolution = new_resolution
	OS.set_window_size(new_resolution)
	Settings.set_setting("graphics", "horizontal_resolution", 1280)
	Settings.set_setting("graphics", "vertical_resolution", 720) 

func _set_fullscreen(value: bool) -> void:
	is_fullscreen = value
	OS.window_fullscreen = is_fullscreen 
	Settings.set_setting("graphics", "is_fullscreen", is_fullscreen)

func _set_master_volume(value: float) -> void: 
	master_volume = value 
	AudioServer.set_bus_volume_db(masterBus, linear2db(value)) 
	Settings.set_setting("audio", "master_volume", master_volume)

func _set_bgm_volume(value: float) -> void:
	bgm_volume = value
	AudioServer.set_bus_volume_db(bgmBus, linear2db(value)) 
	Settings.set_setting("audio", "bgm_volume", bgm_volume) 

func _set_sfx_volume(value: float) -> void: 
	sfx_volume = value
	AudioServer.set_bus_volume_db(sfxBus, linear2db(value)) 
	Settings.set_setting("audio", "sfx_volume", sfx_volume)
