extends KinematicProp
class_name CardDrop
# A random card drop. Gravitates toward player
# when in range. Contains CardData which, when picked up,
# will be added to the colliding player's deck.

onready var cardData = CardData.new((CardLibrary.get_random_card_index()))
onready var animationPlayer = $AnimationPlayer
onready var cardNameLabel = $CardName
onready var pickupPrompt = $PickupPrompt

func _ready() -> void:
	playerDetector.connect("body_exited", self, "_on_playerDetector_body_exited")
	cardNameLabel.text = cardData.text_name
	pickupPrompt.text = InputMap.get_action_list("interact")[0].as_text()

func _on_playerDetector_body_entered(_body) -> void:
	animationPlayer.play("name_reveal") 

func _on_playerDetector_body_exited(_body) -> void:
	animationPlayer.play_backwards("name_reveal")