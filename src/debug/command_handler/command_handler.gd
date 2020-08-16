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
	["set_speed",
		[ARG_INT]],
	["get_coords",
		[ARG_VOID]],
	["spawn",
		[ARG_STRING, ARG_INT, ARG_INT]],
	["kill_all_enemies",
		[ARG_VOID]],
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
	return str("Not implemented.")

func set_speed(new_speed) -> String:
	var player = _get_player() 
	if player == null:
		return str("No player found.")
	
	player.MAX_SPEED = new_speed
	return str("Player speed set to ", new_speed, ".") 

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

	
