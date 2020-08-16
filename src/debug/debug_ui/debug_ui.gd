extends Control

# The debug UI. Allows control of the game within the game for debugging purposes.

onready var input = $Input 
onready var output = $Output 
onready var current_line: int = CommandHistory.get_current_line() 

func _ready() -> void: 
	input.connect("text_entered", self, "_on_input_text_entered") 
	input.grab_focus()

func _input(event) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_UP:
			input.text = CommandHistory.return_to_line(current_line, -1)
			current_line -= 1
		elif event.scancode == KEY_DOWN:
			input.text = CommandHistory.return_to_line(current_line, 1)
			current_line += 1

		input.set_cursor_position(9999999)
		input.grab_focus()

# Here we begin parsing the command by "splitting" the text into words,
# seperated by spaces. Unfortunately, it returns as a PoolStringArray, so
# we need to cast it as an array.
func parse_command(text: String) -> void:
	var words = text.split(" ")
	words = Array(words) 

	for _i in range(words.count("")):
		words.erase("") 

	if words.size() > 0:
		CommandHistory.append(text)
		var command_word = words.pop_front() 
		for command in CommandHandler.valid_commands:
			# See CommandHandler; commands are stored within arrays as arrays.
			if command[0] == command_word:
				# Here we check if the number of input arguments matches
				# the required amount for the particular function
				if words.size() != command[1].size() and command[1][0] != CommandHandler.ARG_VOID:
					output_text(str("Failed to execute command ", command_word, ", expected ", command[1].size(), " arguments."))
					return
				for word in range(words.size()):
					if not _check_type(words[word], command[1][word]):
						output_text(str("Failed to execute command ", command_word, ", expected ", command[1].size(), " arguments. Argument ", (word + 1),
									"( ", words[word], ") is of the wrong type."))
						return 
				
				# Outputting it actually calls the function.
				output_text("RETURN: " + CommandHandler.callv(command_word, words))
				return 

		output_text(str("Command ", command_word, " does not exist."))
		

func output_text(text: String) -> void:
	output.text = str(output.text, "\n", text) 
	output.set_v_scroll(999999)

func _check_type(string: String, type) -> bool:
	if type == CommandHandler.ARG_INT:
		return string.is_valid_integer() 
	elif type == CommandHandler.ARG_FLOAT:
		return string.is_valid_float() 
	elif type == CommandHandler.ARG_STRING:
		return true
	elif type == CommandHandler.ARG_BOOL:
		return true 
	else:
		return false 

func _on_input_text_entered(new_text: String) -> void:
	input.clear()
	parse_command(new_text)
	current_line = CommandHistory.get_current_line()
