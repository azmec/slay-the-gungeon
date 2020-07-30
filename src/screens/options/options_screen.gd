extends Control

# Scuffed control screen. Ideally, this is something that
# can be instanced onto another screen, allowing the player 
# to change options mid-game. 

signal backButton_pressed() 

onready var videoOptions = $VideoOptions
onready var audioOptions = $AudioOptions
onready var controlOptions = $ControlOptions 
onready var backButton = $BackButton 

onready var videoSector = $VideoSector 
onready var audioSector = $AudioSector 
onready var controlSector = $ControlSector 

func _ready():
	videoOptions.connect("pressed", self, "_on_videoOptions_pressed")
	audioOptions.connect("pressed", self, "_on_audioOptions_pressed")
	controlOptions.connect("pressed", self, "_on_controlOptions_pressed") 
	backButton.connect("pressed", self, "_on_backButton_pressed")
 
func _on_videoOptions_pressed() -> void:
	audioSector.visible = false
	controlSector.visible = false
	videoSector.visible = true

func _on_audioOptions_pressed() -> void: 
	videoSector.visible = false
	controlSector.visible = false
	audioSector.visible = true

func _on_controlOptions_pressed() -> void:
	audioSector.visible = false
	videoSector.visible = false
	controlSector.visible = true

func _on_backButton_pressed() -> void:
	emit_signal("backButton_pressed")