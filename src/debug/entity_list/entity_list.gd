extends Node

# Contains paths to all entity scenes. 

var _list = {
	"small_slime": "res://src/character_objects/enemies/slime/slime.tscn",
	"archer_goblin": "res://src/character_objects/enemies/gremlin/gremlin.tscn",
	"slime_king": "res://src/character_objects/bosses/slime_king/slime_king.tscn"
} 

func get_entity_path(entity: String) -> String:
	if !_list.has(entity):
		return "null"
	else:
		return _list[entity]
