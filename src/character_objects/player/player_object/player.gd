extends KinematicBody2D

# Player object.

enum {
	IDLE, 
	RUN,
	DASH
}

const MAX_SPEED: int = 150
const DASH_SPEED: int = 400
const DASH_TIME: float = 0.2
const ACCELERATION: int = 900
const FRICTION: int = 800
const CAMERA_MOVE_SPEED: int = 2
const SWORD_PROJECTILE: Resource = preload("res://src/compositional_objects/bullets/sword_projectile/sword_projectile.tscn") 
const GHOST_EFFECT: Resource = preload("res://src/compositional_objects/ghost_effect/ghost_effect.tscn") 

var state: int = 0
var velocity: Vector2 = Vector2.ZERO
var input_vector: Vector2 = Vector2.ZERO
var attacking: bool = false
var hand_raised: bool = false
var maximum_deck_size = 12
var maximum_hand_size = 5
var mana = 0 
var max_mana = 10
var deck = CardDatabase.new("player_deck")
var hand = CardDatabase.new("player_hand")

onready var animationPlayer = $AnimationPlayer
onready var camera = $Camera2D
onready var sword = $Sword
onready var sprite = $AnimatedSprite
onready var healthStats = $HealthStats
onready var swordAnimationPlayer = $SwordAnimationPlayer
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var healthbarUI = $CanvasLayer/Healthbar
onready var canvasLayer = $CanvasLayer
onready var cardContainer = $CardContainer
onready var deckCount = $CanvasLayer/DeckCount
onready var handWidget = $CanvasLayer/HandWidget
onready var drawButton = $CanvasLayer/DrawButton
onready var swordTween = $Sword/SwordTween 
onready var dashTimer = $DashTimer
onready var ghostTimer = $GhostTimer
onready var manaDisplay = $CanvasLayer/ManaDisplay
onready var discardButton = $CanvasLayer/DiscardButton

func _ready() -> void:
	randomize()
	hurtbox.connect("damage_taken", self, "_on_damage_taken")
	blinkAnimationPlayer.connect("animation_finished", self, "_on_blink_finished")
	swordAnimationPlayer.connect("animation_finished", self, "_on_sword_animation_finished")
	drawButton.connect("pressed", self, "_on_draw_button_pressed") 
	discardButton.connect("pressed", self, "_on_discard_button_pressed")
	dashTimer.connect("timeout", self, "_on_dashTimer_timeout")
	ghostTimer.connect("timeout", self, "_on_ghostTimer_timeout")
	handWidget.set_hand(hand, deck, self)
	mana = max_mana
	
func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			idle(delta)
		RUN:
			run(delta)
		DASH:
			dash(delta)
	camera_look()
	velocity = move_and_slide(velocity)
	
	#if Input.is_action_just_pressed("attack") and not attacking:
		#swordAnimationPlayer.play("attack")
		#var new_projectile = SWORD_PROJECTILE.instance()
		#get_parent().add_child(new_projectile)
		#new_projectile.spawn(self.global_position, Vector2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0, JOY_AXIS_3)))
		#new_projectile.spawn(self.global_position, get_local_mouse_position())
		#attacking = true
	if Input.is_action_just_pressed("raise_card_ui"):
		toggle_hand_widget() 
	deckCount.text = str(deck.count())
	healthbarUI.healthSliver.rect_size.x = (healthStats.health / float(healthStats.max_health)) * 100 - 37
	manaDisplay.rect_size.x = 32 * mana 

func toggle_hand_widget() -> void:
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
	for card in maximum_hand_size:
		if deck.count() != 0:
			var new_draw = deck.draw_card()
			hand.add_card(new_draw)
	
func draw_random_card_from_hand() -> void:
	var random_card = hand.draw_card()
	var random_playable_card = load("res://src/card_architecture/card_default/card_default.tscn").instance()
	random_playable_card.initialize_card(random_card)
	cardContainer.add_child(random_playable_card)
	random_playable_card._play_card()

func reset() -> void:
	deck.clear()
	hand.clear()
	for children in cardContainer.get_children():
		children.call_deferred("free")

func idle(delta: float) -> void:
	get_input()
	animationPlayer.play("idle")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	if input_vector != Vector2.ZERO:
		state = RUN

func run(delta: float) -> void:
	get_input()
	animationPlayer.play("run")
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	if input_vector == Vector2.ZERO:
		state = IDLE  
	if Input.is_action_just_pressed("dash"):
		state = DASH
		dashTimer.start(DASH_TIME)

func dash(delta: float) -> void:
	#get_input()
	velocity = velocity.move_toward(input_vector * DASH_SPEED, ACCELERATION * delta) 

func get_input():
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

func camera_look() -> void:
	var axis = get_local_mouse_position()
	#var axis = Vector2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0, JOY_AXIS_3)) * 125
	camera.position.x = (0 + axis.x) / 2
	camera.position.y = (0 + axis.y) / 2

	sword.rotation = axis.angle()
	if sword.rotation < 0:
		sword.z_index = -1
	else:
		sword.z_index = 0

	sprite.flip_h = axis.x < -2.5

func _on_dashTimer_timeout() -> void:
	state = IDLE 

func _on_ghostTimer_timeout() -> void:
	if state != DASH: return 

	var ghost = GHOST_EFFECT.instance()
	get_parent().add_child(ghost)
	ghost.texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
	ghost.flip_h = sprite.flip_h
	ghost.position = self.position 

func _on_damage_taken(damage: int, knockback: Vector2) -> void:
	healthStats.health = healthStats.health - damage
	velocity = knockback
	blinkAnimationPlayer.play("blink")
	hurtbox.set_deferred("monitoring", false)

func _on_blink_finished(_anim_name: String) -> void:
	hurtbox.set_deferred("monitoring", true)

func _on_sword_animation_finished(_anim_name: String) -> void:
	attacking = false

func _on_draw_button_pressed() -> void:
	if deck.count() == 0: return
	var new_draw = deck.draw_card()
	hand.add_card(new_draw)

func _on_discard_button_pressed() -> void:
	if hand.count() == 0: return 
	for card in hand.count():
		var new_draw = hand.draw_card()
		deck.add_card(new_draw) 
	draw_hand()