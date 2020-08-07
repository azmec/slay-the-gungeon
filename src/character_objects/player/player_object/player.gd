class_name Player
extends CharacterBody

# Player object.

enum {
	IDLE, 
	RUN,
	DASH,
	DEAD
}

const DASH_SPEED: int = 400
const DASH_TIME: float = 0.2
const CAMERA_MOVE_SPEED: int = 2
const SWORD_PROJECTILE: Resource = preload("res://src/compositional_objects/bullets/sword_projectile/sword_projectile.tscn") 
const GHOST_EFFECT: Resource = preload("res://src/compositional_objects/ghost_effect/ghost_effect.tscn") 

var state: int = 0
var input_vector: Vector2 = Vector2.ZERO
var hand_raised: bool = false
var maximum_deck_size = 12
var maximum_hand_size = 5
var max_mana = 3
var level = 1 setget _set_player_level
var deck = CardDatabase.new("player_deck")
var hand = CardDatabase.new("player_hand")
var discard_pile = CardDatabase.new("player_discard_pile")
var interactablePickup = null

onready var camera = $Camera2D
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var pickupDetector = $PickupDetector
onready var healthbarUI = $CanvasLayer/Healthbar
onready var manaBarUI = $CanvasLayer/Manabar
onready var canvasLayer = $CanvasLayer
onready var deckCount = $CanvasLayer/DeckCount
onready var discardPileCount = $CanvasLayer/DiscardPile/Label
onready var handWidget = $CanvasLayer/HandWidget
onready var drawButton = $CanvasLayer/DrawButton
onready var dashTimer = $DashTimer
onready var ghostTimer = $GhostTimer
onready var discardButton = $CanvasLayer/HandWidget/DiscardButton 
onready var walkParticles = $CPUParticles2D

onready var mana = max_mana setget _set_mana

func _init():
	MAX_SPEED = 150
	ACCELERATION = 900
	FRICTION = 800 

func _ready() -> void:
	randomize()
	blinkAnimationPlayer.connect("animation_finished", self, "_on_blink_finished")
	drawButton.connect("pressed", self, "_on_draw_button_pressed") 
	discardButton.connect("pressed", self, "_on_discard_button_pressed")
	dashTimer.connect("timeout", self, "_on_dashTimer_timeout")
	ghostTimer.connect("timeout", self, "_on_ghostTimer_timeout")
	pickupDetector.connect("body_entered", self, "_on_pickupDetector_body_entered")
	pickupDetector.connect("body_exited", self, "_on_pickupDetector_body_exited")

	mana = max_mana
	deck = CardLibrary.draft_player_deck()
	handWidget.set_hand(hand, deck, discard_pile, self)
	draw_hand()
	
	
func _physics_process(delta: float) -> void: 
	match state:
		IDLE:
			idle(delta)
		RUN:
			run(delta)
		DASH:
			dash(delta)
		DEAD:
			dead(delta) 
	
	camera_look()
	walkParticles.gravity = input_vector * -98
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("raise_card_ui"):
		toggle_hand_widget() 

	if hand.count() == 0:
		discard_hand()
		draw_hand()

	if interactablePickup != null:
		if Input.is_action_just_pressed("interact"):
			if interactablePickup is CardDrop:
				deck.add_card(interactablePickup.cardData) 
				interactablePickup.queue_free()
				interactablePickup = null
	deckCount.text = str(deck.count())
	discardPileCount.text = str(discard_pile.count())
	healthbarUI.healthSliver.rect_size.x = (healthStats.health / float(healthStats.max_health)) * 80
	healthbarUI.numericDisplay.text = str(healthStats.health) + "/" + str(healthStats.max_health)
	manaBarUI.numericDisplay.text = str(mana) + "/" + str(max_mana)
	manaBarUI.healthSliver.rect_size.x = (mana / float(max_mana)) * 80


func increase_player_level() -> void:
	self.level += 1 

func toggle_hand_widget() -> void:
	if state == DEAD: return
	handWidget.move_hand()
	self.hand_raised = handWidget.raised
	if hand_raised: 
		Engine.time_scale = 0.2
	else:
		Engine.time_scale = 1.0 

func create_deck() -> void:
	for card in maximum_deck_size:
		var new_card_id = CardLibrary.get_random_card_index()
		var new_card = CardData.new(new_card_id)
		deck.add_card(new_card) 
		#print(new_card.card_name)

func draw_hand() -> void:
	var draw_array = []
	while draw_array.size() != maximum_hand_size:
		if deck.count() != 0:
			var new_draw = deck.draw_card()
			draw_array.push_front(new_draw)
		else:
			for card in discard_pile.count():
				if discard_pile.count() == 0: return
				var new_draw = discard_pile.draw_card()
				deck.add_card(new_draw)

	
	hand.add_multiple_cards(draw_array)

func discard_hand() -> void:
	var draw_array = []
	for card in hand.count():
		var new_draw = hand.draw_card()
		draw_array.push_front(new_draw)

	discard_pile.add_multiple_cards(draw_array) 
	mana = max_mana

func reset() -> void:
	deck.clear()
	hand.clear()

func idle(delta: float) -> void:
	get_input()
	#walkParticles.emitting = false
	animationPlayer.play("idle")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	if input_vector != Vector2.ZERO:
		state = RUN

func run(delta: float) -> void:
	get_input()
	#walkParticles.emitting = true
	animationPlayer.play("run")
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	if input_vector == Vector2.ZERO:
		state = IDLE  
	if Input.is_action_just_pressed("dash"):
		state = DASH
		$Sounds/Dash.play()
		camera.trauma += 0.2
		dashTimer.start(DASH_TIME)

func dash(delta: float) -> void:
	#get_input()
	#walkParticles.emitting = false
	velocity = velocity.move_toward(input_vector * DASH_SPEED, ACCELERATION * delta) 

func dead(delta: float) -> void:
	animationPlayer.play("dead")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 

func get_input():
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

func camera_look() -> void:
	if state == DEAD: return 

	var axis = get_local_mouse_position() 

	camera.position.x = (0 + axis.x) / 2
	camera.position.y = (0 + axis.y) / 2

	sprite.flip_h = axis.x < -2.5

func _set_player_level(value) -> void:
	level = value
	max_mana += 1 
	healthStats.max_health += 1 

func _set_mana(value: int) -> void:
	if value > max_mana:
		mana = max_mana 
		return
	manaBarUI.trauma += value * 0.5 
	$Sounds/ManaPickup.play()
	mana = value
	
func _on_dashTimer_timeout() -> void:
	state = IDLE 

func _on_ghostTimer_timeout() -> void:
	if state != DASH: return 

	var ghost = GHOST_EFFECT.instance()
	get_parent().add_child(ghost)
	ghost.texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
	ghost.flip_h = sprite.flip_h
	ghost.position = self.position 

func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void:
	if state == DEAD:
		hurtbox.set_deferred("monitoring", true)
		velocity = knockback
		return
	OS.delay_msec(15)
	healthStats.health = healthStats.health - damage
	blinkAnimationPlayer.play("blink")
	hurtbox.set_deferred("monitoring", false)
	camera.trauma += (damage * 4) * 0.1 
	healthbarUI.trauma += (damage) * 0.5 

func _on_pickupDetector_body_entered(body) -> void:
	interactablePickup = body 
	if body is HealthPickup:
		healthStats.health += body.heal
		body.queue_free()

func _on_pickupDetector_body_exited(_body) -> void:
	interactablePickup = null

func _on_no_health() -> void:
	state = DEAD 
	walkParticles.emitting = false
	self.z_index = 0
	emit_signal("character_died", self.global_position)

func _on_blink_finished(_anim_name: String) -> void:
	hurtbox.set_deferred("monitoring", true)

func _on_draw_button_pressed() -> void:
	if deck.count() == 0: return
	var new_draw = deck.draw_card()
	hand.add_card(new_draw)

func _on_discard_button_pressed() -> void:
	discard_hand()
