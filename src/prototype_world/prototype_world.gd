extends Node2D

const GREMLIN_ENEMY = preload("res://src/character_objects/enemies/gremlin/gremlin.tscn") 
const SLIME_ENEMY = preload("res://src/character_objects/enemies/slime/slime.tscn")
const EXIT_PORTAL = preload("res://src/compositional_objects/exit_portal/exit_portal.tscn")

var enemy_pool = [GREMLIN_ENEMY, SLIME_ENEMY]

var borders = Rect2(1, 1, 320, 160)
var level_points: Array
var difficulty: int = 1
var live_enemies = []
var level_data

onready var tileMap = $TileMap 
onready var player = $Player
onready var enemies = $Enemies
onready var deathMenu = $CanvasLayer/DeathMenu
onready var floorGround = $Floor


func _ready() -> void:
	randomize()
	generate_new_level()

func generate_new_level():
	var new_level = LevelLibrary.get_random_level() 
	tileMap.tile_set = load(new_level["world_art"]["wall_tileset"])
	enemy_pool = new_level["enemies"].values()
	floorGround.texture = load(new_level["world_art"]["ground_tile_rect"])

	var level_generator = LevelGenerator.new(Vector2(120, 80),
			700, borders, difficulty, enemy_pool, tileMap, floorGround)
	self.add_child(level_generator)
	level_generator.generate_level(player) 
	level_data = level_generator.get_data()

	for character in get_tree().get_nodes_in_group("characters"):
		character.connect("character_died", self, "_on_character_died", [character]) 

	level_generator.queue_free()

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
	
func spawn_exit_level_portal(character: CharacterBody) -> void:
	var new_portal = EXIT_PORTAL.instance() 
	add_child(new_portal)
	new_portal.global_position = character.global_position
	new_portal.connect("player_entered", self, "_on_new_portal_player_entered", [new_portal])

func _on_new_portal_player_entered(portal: Node2D) -> void:
	wipe_current_level()
	call_deferred("generate_new_level")
	portal.disconnect("player_entered", self, "_on_new_portal_player_entered") 
	portal.call_deferred("queue_free")

func _on_character_died(character_position: Vector2, character: CharacterBody) -> void:
	if character is EnemyBody:
		print("Enemy died.")
		level_data["enemies"].erase(character)
		if level_data["enemies"].size() == 0:
			call_deferred("spawn_exit_level_portal", character)
	elif character is Player:
		deathMenu.visible = true

