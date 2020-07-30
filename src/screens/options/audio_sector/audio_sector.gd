extends Control

# Audio sector of options. 

onready var bgmSlider = $BGMSlider 
onready var sfxSlider = $SFXSlider

func _ready() -> void:
	bgmSlider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM")))
	sfxSlider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	bgmSlider.connect("value_changed", self, "_on_bgmSlider_value_changed") 
	sfxSlider.connect("value_changed", self, "_on_sfxSlider_value_changed")

func _on_bgmSlider_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear2db(new_value))

func _on_sfxSlider_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(new_value))