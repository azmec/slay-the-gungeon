extends Control

# Scuffed control screen. Ideally, this is something that
# can be instanced onto another screen, allowing the player 
# to change options mid-game. 

onready var videoOptions = $VideoOptions
onready var audioOptions = $AudioOptions
onready var controlOptions = $ControlOptions 
onready var backButton = $BackButton 

func _ready():
	videoOptions.connect("pressed", self, "_on_videoOptions_pressed")
	audioOptions.connect("pressed", self, "_on_audioOptions_pressed")
	controlOptions.connect("pressed", self, "_on_controlOptions_pressed") 
	backButton.pressed("pressed", self, "_on_backButton_pressed")