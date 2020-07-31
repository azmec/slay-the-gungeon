extends Control

# Audio sector of options. 

onready var masterSlider = $MasterVolume/MasterSlider
onready var bgmSlider = $BGMVolume/BGMSlider 
onready var sfxSlider = $SFXVolume/SFXSlider

func _ready() -> void:
	masterSlider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	bgmSlider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM")))
	sfxSlider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	masterSlider.connect("value_changed", self, "_on_masterSlider_value_changed")
	bgmSlider.connect("value_changed", self, "_on_bgmSlider_value_changed") 
	sfxSlider.connect("value_changed", self, "_on_sfxSlider_value_changed")

func _on_masterSlider_value_changed(new_value: float) -> void: 
	Options.master_volume = new_value
	
func _on_bgmSlider_value_changed(new_value: float) -> void:
	Options.bgm_volume = new_value

func _on_sfxSlider_value_changed(new_value: float) -> void:
	Options.sfx_volume = new_value
