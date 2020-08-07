extends Node2D

const GREMLIN_ENEMY = preload("res://src/character_objects/enemies/gremlin/gremlin.tscn") 
const SLIME_ENEMY = preload("res://src/character_objects/enemies/slime/slime.tscn")

var enemy_pool = [GREMLIN_ENEMY, SLIME_ENEMY]

var borders = Rect2(1, 1, 320, 160)
var level_points: Array
var difficulty: int = 1

onready var tileMap = $TileMap 
onready var player = $Player
onready var enemies = $Enemies
onready var deathMenu = $CanvasLayer/DeathMenu
onready var floorGround = $Floor


func _ready() -> void:
	randomize()
	generate_new_level()

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		wipe_current_level()
		generate_new_level() 

func generate_new_level():
	var level_generator = LevelGenerator.new(Vector2(120, 80),
			700, borders, difficulty, enemy_pool, tileMap, floorGround)
	self.add_child(level_generator)
	level_generator.generate_level(player)

	for character in get_tree().get_nodes_in_group("characters"):
		character.connect("character_died", self, "_on_character_died", [character]) 

# Wipes the current level without deleting player variables.
# Additionally, it will up the difficulty and alter level "theme".
func wipe_current_level():
	tileMap.clear() 

	for character in get_tree().get_nodes_in_group("characters"):
		character.disconnect("character_died", self, "_on_character_died") 
		
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	
	for prop in get_tree().get_nodes_in_group("props"):
		prop.queue_free() 

	difficulty += 1
	player.increase_player_level()

func _on_character_died(character_position: Vector2, character: CharacterBody) -> void:
	if character is Player:
		deathMenu.visible = true

