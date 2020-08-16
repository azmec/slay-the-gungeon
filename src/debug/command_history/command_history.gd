extends Node

# Has the exclusive purpose of storing the command history. 

var history = [] 

func return_to_line(current_line: int, offset: int) -> String:
	var new_line = (current_line + offset)
	new_line = clamp(new_line, 0, history.size()) 
	if new_line < history.size() and history.size() > 0:
		return history[new_line]
	else:
		return ""

func append(new_line: String) -> void:
	history.append(new_line)

func get_current_line() -> int:
	return history.size()