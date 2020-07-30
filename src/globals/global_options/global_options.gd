extends Control

# Global options are managed here. 
# Things like audio volume, controls, graphical options, etc. 

# Temporary variables. We don't save these. 

const OPTIONS_SAVE_PATH: String = "res://options_save.json" 

var settings: Dictionary = {}

# Saved variables. Things the player would prefer to be constant. 

var master_volume: int = 0 
var sfx_volume: int = 0
var bgm_volume: int = 0

var is_master_muted: bool = false
var is_sfx_muted: bool = false 
var is_bgm_muted: bool = false 

var resolution_width: int = 1280
var resolution_height: int = 720 
var is_fullscreen: bool = false 


