extends Node

# Contains path references and enemy pools for each type of level. 
 
const LEVELS = {
	"level_1": {
		"level_name": "Quelled Forest",
		"world_art": {
			"wall_tileset": "res://src/tileset_files/forest_wall.tres",
			"ground_tile_rect": "res://assets/sprites/tile_art/world_1/grass_background_texture.png"
		},
		"enemies": {
			"enemy_1": "res://src/character_objects/enemies/gremlin/gremlin.tscn",
			"enemy_2": "res://src/character_objects/enemies/slime/slime.tscn"
		},
	}
} 

func get_random_level() -> Dictionary:
	var library_keys = LEVELS.keys() 
	var random_level = library_keys[randi() % library_keys.size()] 
	return LEVELS[random_level]