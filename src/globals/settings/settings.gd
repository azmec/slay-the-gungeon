extends Node

# Here we get current settings and write them to 
# the config file. 

const SAVE_PATH = "res://config.cfg" 

var _config_file = ConfigFile.new() 

var _settings = {
	"graphics": {
		"horizontal_resolution": 720,
		"vertical_resolution": 1280,
		"is_fullscreen": false
	},
	"audio": {
		"master_volume": 1,
		"bgm_volume": 1, 
		"sfx_volume": 1,
	},
} 

func _ready() -> void:
	save_settings()
	load_settings() 

func save_settings() -> void:
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key]) 

	_config_file.save(SAVE_PATH)

func load_settings():
	# Open the file & store its return in error
	var error = _config_file.load(SAVE_PATH) 
	# Verify it opened correctly 
	if error != OK:
		print("Failed loading settings. ERROR CODE: %s", error)
		return error
	# Retrive values 
	for section in _settings.keys():
		for key in _settings[section]:
			var val = _config_file.get_value(section, key)
			_settings[section][key] = val 

	return error 

func get_setting(catergory, key):
	return _settings[catergory][key] 

func set_setting(catergory, key, value): 
	_settings[catergory][key] = value
