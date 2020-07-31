extends Control

# The absolute bitch of customization. Serves to allow control 
# customization, preferably to the fullest extent. Additionally 
# accounts for gamepad. 

# It should be noted that all children of "Actions" (keyboard and gamepad respectively), 
# MUST be EXACTLY named according to the action they represent. The same goes for anything
# in the ACTIONS enum. 

enum ACTIONS {
	move_up,
	move_down,
	move_left,
	move_right,
	attack,
	raise_card_ui,
	select,
	dash,
	pause,
}

onready var keyActions = $KeyboardControls/ScrollContainer/Actions

var can_change_key: bool = false
var current_key_action: String 

func _ready() -> void:
	for action_entry in keyActions.get_children():
		action_entry.button.connect("pressed", self, "_on_key_action_entry_button_pressed", [action_entry])
	_set_key_text()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and can_change_key:
		_change_key(event) 
		_set_key_text()
		can_change_key = false

func _set_key_text() -> void:
	for action in ACTIONS:
		var action_entry = get_node("KeyboardControls/ScrollContainer/Actions/" + str(action))
		action_entry.button.set_pressed(false)
		if !InputMap.get_action_list(action).empty():
			action_entry.button.text = str(InputMap.get_action_list(action)[0].as_text())
		else:
			action_entry.button.text = "No button assigned."


# Changes the input by saving a reference array of our current inputs for a given action and 
# modifying the [0] index for that array. Only then do we erase all events for that action
# and reinstate them by going through the array. This way, we only modify the [0] index.
func _change_key(new_key) -> void: 
	var input_array = InputMap.get_action_list(current_key_action)
	input_array[0] = new_key  
	InputMap.action_erase_events(current_key_action)
	for input in input_array:
		InputMap.action_add_event(current_key_action, input)



func _on_key_action_entry_button_pressed(action_entry) -> void:
	can_change_key = true
	current_key_action = action_entry.get_name() 

	for action in ACTIONS:
		if action != action_entry.get_name():
			action_entry.button.set_pressed(false)
			