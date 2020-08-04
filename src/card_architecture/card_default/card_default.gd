extends Node2D
class_name PlayableCard

# Base card. Intended to be used with its scene: card_default.tscn 

signal mouse_entered()
signal mouse_exited()
signal mouse_motion_detected(relative)
signal mouse_pressed(button)
signal mouse_released(button)

# Decoupling animation and making it a reference
class AnimationState extends Reference:
	var pos = Vector2(0, 0)
	var rot = 0
	var scale = Vector2(1, 1)

export var default_size: Vector2 = Vector2(1.0, 1.0)

# Time it takes for animation in seconds
export var animation_speed: float = 0.2

var default_z_index: int = 0 setget set_default_z_index
var _is_ready: bool = false 
var _animation: Tween = Tween.new()
var _animation_stack = []

var _card_data: CardData 
var _holder
var id: Dictionary = {"000": ""}
var attributes: Dictionary = {}
var card_name: String = "Nothing"
var text_name: String = "Nothing"
var type: String = "None" 
var cost: int = 0
var desc: String = "Nothing to see here."
var image: Resource
var components: Array = []

onready var sprite = $Sprite
onready var description_label = $CardRect/Description
onready var name_label = $CardRect/Name 
onready var cost_label = $CardRect/Cost
onready var mouseArea = $MouseArea
onready var componentContainer = $ComponentContainer


func _init():
	add_child(_animation)
	#_animation.repeat = true

func _ready() -> void:
	_is_ready = true
	mouseArea.connect("mouse_entered", self, "_on_mouse_area_entered")
	mouseArea.connect("mouse_exited", self, "_on_mouse_area_exited")
	mouseArea.connect("gui_input", self, "_on_mouse_area_gui_input")
	_animation.connect("tween_completed", self, "_on_animation_completed")

	sprite.texture = image
	description_label.bbcode_text = "[center]" + desc + "[/center]"
	name_label.text = text_name 
	cost_label.text = str(cost)

	_animation.start()

	_read_card_data()

func _exit_tree() -> void:
	_animation.stop_all()

func initialize_card(new_data: CardData, card_holder) -> void: 
	_holder = card_holder
	_card_data = new_data
	self.id = new_data.id
	self.attributes = new_data.attributes
	self.card_name = new_data.card_name
	self.text_name = new_data.text_name
	self.type = new_data.type
	self.cost = new_data.cost
	self.desc = new_data.desc
	self.image = load(new_data.sprite_path)
	self.components = new_data.components
 
func play_card():
	for component in componentContainer.get_children():
		component.play() 

# Adds an animation state from the current values
# i.e. stores the current visual state of the card into
# something we can return to
func push_animation_state_from_current_values() -> void:
	var state = AnimationState.new()
	state.pos = self.position
	state.rot = self.rotation
	state.scale = self.scale
	_animation_stack.push_back[state]

func push_animation_state(pos: Vector2, rot: float, scale_ratio: Vector2, pos_relative: bool = false, rot_relative: bool = false, scale_relative: bool = false):
	var previous_state = null
	if !_animation_stack.empty():
		previous_state = _animation_stack.back()
	else:
		previous_state = AnimationState.new()
		previous_state.pos = self.position
		previous_state.rot = self.rotation
		previous_state.scale = self.scale 

	var state = AnimationState.new()
	state.pos = pos if !pos_relative else previous_state.pos + pos
	state.rot = rot if !rot_relative else previous_state.rot + rot
	state.scale = scale_ratio if !scale_relative else previous_state.scale*scale_ratio

	_animation_stack.push_back(state)
	_animate(previous_state, state) 

# Remove the last animation state and animate the card to the previous state.
func pop_animation_state() -> void:
	if _animation_stack.empty(): return
	#print(str(self.card_name), "'s animation state is being popped!")
	var state = _animation_stack.pop_back()
	if !_animation_stack.empty():
		var previous_state = _animation_stack.back()
		_animate(state, previous_state)

func calculate_scale(size: Vector2) -> Vector2:
	var ratio = size / default_size
	var result = Vector2(1, 1)
	if ratio.x > ratio.y:
		result = Vector2(ratio.y, ratio.y)
	else:
		result = Vector2(ratio.x, ratio.x)
	return result

func set_default_z_index(value: int) -> void:
	default_z_index = value
	self.z_index = value

func get_card_data():
	return _card_data 

func bring_to_front() -> void:
	z_index = VisualServer.CANVAS_ITEM_Z_MAX

func send_to_back() -> void:
	z_index = VisualServer.CANVAS_ITEM_Z_MIN

func reset_z_index() -> void:
	z_index = default_z_index
# TODO: Tweens stops working after letting them finish their animation.
# FIXED by appending "_animation.start()" at the end of this function. Something
# must be calling "_animation.stop()" somewhere, but this reverses it.
func _animate(from_state, to_state) -> void:
	_animation.interpolate_property(
		self, "position", from_state.pos, to_state.pos, animation_speed, Tween.TRANS_BACK, Tween.EASE_OUT
	) 
	_animation.interpolate_property(
		self, "rotation_degrees", from_state.rot, to_state.rot, animation_speed, Tween.TRANS_BACK, Tween.EASE_OUT
	) 
	_animation.interpolate_property(
		self, "scale", from_state.scale, to_state.scale, animation_speed, Tween.TRANS_BACK, Tween.EASE_OUT
	) 
	_animation.start()

func _read_card_data() -> void:
	for component in components:
		if component["action"] == "damage":
			var damage_component = load("res://src/card_architecture/action_components/damage/damage_component.tscn").instance()
			componentContainer.add_child(damage_component)
			damage_component.load_arguments(component["args"], _holder) 
		if component["action"] == "draw":
			component["args"]["deck"] = _holder.deck
			component["args"]["hand"] = _holder.hand
			var draw_component = load("res://src/card_architecture/action_components/draw/draw_component.tscn").instance() 
			componentContainer.add_child(draw_component)
			draw_component.load_arguments(component["args"]) 
		if component["action"] == "radial_damage":
			var radial_damage_component = load("res://src/card_architecture/action_components/radial_damage/radial_damage_component.tscn").instance()
			componentContainer.add_child(radial_damage_component)
			radial_damage_component.load_arguments(component["args"], _holder)

func _play_card() -> void:
	for component in components:
		if component.has("action"):
			if component["action"] == "damage":
				print("This is a damaging card.")
			elif component["action"] == "discover":
				print("This is a discovering card.")
			elif component["action"] == "draw":
				print("This is a drawing card.") 
		if component.has("args"):
			for key in component["args"]:
				if key == "targets": 
					print("This card has " + str(component["args"][key]) + " target(s).")
				if key == "amount":
					print("This card deals " + str(component["args"][key]) + "." ) 
				if key == "randomly":
					if component["args"][key] == true:
						print("This card deals damage randomly.")
					else:
						print("This card deals damage based on target(s).")
				if key == "radius":
					if component["args"][key] == true:
						print("This card deals damage in a radius")
					else:
						print("This card does not deal dmage in a radius.")

func _on_mouse_area_entered() -> void:
	emit_signal("mouse_entered")

func _on_mouse_area_exited() -> void: 
	emit_signal("mouse_exited")

func _on_mouse_area_gui_input(event) -> void:
	if event is InputEventMouseMotion:
		emit_signal("mouse_motion_detected", event.relative)
	elif event is InputEventMouseButton:
		if event.pressed:
			emit_signal("mouse_pressed", event.button_index)
		else:
			emit_signal("mouse_released", event.button_index)

func _on_animation_completed(object: Object, key: String) -> void:
	#print(str(self.card_name), "'s animation is completed!'")
	_animation.remove(object, key)
