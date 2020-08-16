extends CanvasLayer

# Contains all debug commands and their executions. 

enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT,
	ARG_VOID
}

const DEBUG_CONSOLE = preload("res://src/debug/debug_ui/debug_ui.tscn")

const valid_commands = [
	["get_commands",
		[ARG_VOID]],
	["get_coords",
		[ARG_VOID]],
	["spawn",
		[ARG_STRING, ARG_INT, ARG_INT]],
	["kill_all_enemies",
		[ARG_VOID]],
	["set_player_stat",
		[ARG_STRING, ARG_FLOAT]],
	["get_player_database",
		[ARG_STRING]],
	["remove_card_from_database", 
		[ARG_STRING, ARG_INT]],
	["get_library_catalogue",
		[ARG_VOID]],
	["add_card_to_database",
		[ARG_STRING, ARG_STRING]]
] 

var debug_is_up: bool = false 

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("display_debug_console"):
		if not debug_is_up:
			var new_window = DEBUG_CONSOLE.instance() 
			add_child(new_window) 
			debug_is_up = true
		else:
			for child in self.get_children():
				child.queue_free()
			debug_is_up = false

func get_commands() -> String:
	var command_list = valid_commands.duplicate(true) 
	var returned_list = []
	for command in command_list:
		var returned_command = []
		returned_command.append(command[0])
		for argument in command[1]:
			match argument:
				ARG_VOID:
					argument = "void" 
				ARG_BOOL:
					argument = "bool" 
				ARG_FLOAT:
					argument = "float" 
				ARG_INT:
					argument = "int" 
				ARG_STRING:
					argument = "String" 
					 
			returned_command.append(argument)
		
		returned_list.append(returned_command)

	return str(returned_list)

func set_player_stat(stat: String, value: String) -> String:
	var player = _get_player() 
	if player == null:
		return str("No player found.") 

	if stat in player:
		player.set(stat, float(value))
		return str("Player stat ", stat, " set to ", value, ".")
	else: 
		return str("Player does not have ", stat, "stat.")

func get_player_database(cardDatabase: String) -> String:
	var player = _get_player() 
	if player == null:
		return str("No player found.")  

	var database = player.get(cardDatabase) 
	if database == null:
		return str("No cardDatabase of that name found.")  

	return str(database.card_list()) 

func remove_card_from_database(cardDatabase: String, card_name: String) -> String:
	var player = _get_player() 
	if player == null:
		return str("No player found.") 

	var database = player.get(cardDatabase) 
	if database == null:
		return str("No cardDatabase of that name found.") 

	if database.card_exists(card_name) == false:
		return str("Card not found. Are you referencing the correct id?")
	
	database.remove_card(card_name)
	return str("Card of ", card_name, " id removed.")
	
func get_library_catalogue() -> String:
	return str(CardLibrary.get_catalogue()) 

func add_card_to_database(cardDatabase: String, library_key: String) -> String:
	var player = _get_player() 
	if player == null:
		return str("No player found.") 

	var database = player.get(cardDatabase) 
	if database == null:
		return str("No cardDatabase of that name found.")  

	if !CardLibrary.key_exists(library_key):
		return str("No card of that key exists. Are you referencing the correct id?") 

	database.add_card(CardLibrary.generate_new_card_data(library_key))
	return str(library_key, " added to ", cardDatabase, ".")

func kill_all_enemies() -> String:
	var enemies = _get_enemies() 
	if enemies == []:
		return str("No enemies found.") 

	for enemy in enemies:
		enemy.healthStats.health = 0 

	return str("Killed ", str(enemies.size()), " enemies.") 

func get_coords() -> String:
	var player = _get_player() 
	if player == null:
		return str("No player found.") 

	return str(player.global_position) 

func spawn(entity: String, x_coordinate: String, y_coordinate: String) -> String:
	var world = _get_world()
	if world == null:
		return str("Must be in game world to use this command.") 
	
	var path_to_entity = EntityList.get_entity_path(entity) 
	if path_to_entity == "null":
		return str("Invalid entity name.")
	
	var loaded_entity = load(path_to_entity) 
	var new_entity = loaded_entity.instance() 

	world.add_child(new_entity) 
	new_entity.global_position = Vector2(int(x_coordinate), int(y_coordinate)) 

	return str("Entity spawned at x: ", str(x_coordinate), ", y: ", str(y_coordinate), ".")

func _get_world() -> Node:
	return get_node("/root/World") 

func _get_player() -> CharacterBody:
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() == 0:
		return null
	else:
		return player_group[0]

func _get_enemies() -> Array: 
	var world = _get_world()
	if world == null:
		return [] 

	if world.level_data["enemies"].size() == 0:
		return []

	return get_tree().get_nodes_in_group("enemies") 

	
