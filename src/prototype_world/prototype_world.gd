extends Node2D

const GREMLIN_ENEMY = preload("res://src/character_objects/enemies/gremlin/gremlin.tscn") 
const SLIME_ENEMY = preload("res://src/character_objects/enemies/slime/slime.tscn")
const MANA_DROP = preload("res://src/compositional_objects/mana_drop/mana_drop.tscn") 
const GOLDEN_CHEST = preload("res://src/items/golden_chest/golden_chest.tscn")
const NORMAL_CHEST = preload("res://src/items/normal_chest/normal_chest.tscn")

var enemy_pool = [GREMLIN_ENEMY, SLIME_ENEMY]

var borders = Rect2(1, 1, 160, 80)
var level_points: Array
onready var tileMap = $TileMap 
onready var player = $Player
onready var enemies = $Enemies


func _ready() -> void:
	randomize()
	var level_generator = LevelGenerator.new(Vector2(19, 11),
			700, borders, 1, enemy_pool, tileMap, $GrassTileMap)
	self.add_child(level_generator)
	level_generator.generate_level(player)
	#generate_level()
	#spawn_enemies()
	#spawn_chests(3)
	#BGMController.play_new_track("res://assets/bgm/musBoss1.ogg") 

	for character in get_tree().get_nodes_in_group("characters"):
		character.connect("character_died", self, "_on_character_died", [character])

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(700)
	level_points = map
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
		$GrassTileMap.set_cellv(location, randi() % 7)
	tileMap.update_bitmask_region(borders.position, borders.end)
	player.global_position = tileMap.map_to_world(Vector2(19, 11))
		

func spawn_enemies():
	for point in level_points:
		if randf() <= 0.006:
			var enemy = SLIME_ENEMY.instance()
			if randf() <= 0.5:
				enemy = GREMLIN_ENEMY.instance()
			enemies.add_child(enemy)
			enemy.global_position = tileMap.map_to_world(point) 
			if enemy.global_position.distance_to(player.global_position) <= 200:
				enemy.queue_free()	 

	for character in get_tree().get_nodes_in_group("characters"):
		character.connect("character_died", self, "_on_character_died", [character])

func spawn_chests(amount: int) -> void:
	var possible_chest_locations = level_points
	var chest_locations = []

	while chest_locations.size() < 1:
		var furthest_point = Vector2.ZERO
		var furthest_distance = 1
		for point in possible_chest_locations:
			if point.distance_to(Vector2(19, 11)) > furthest_distance:
				furthest_distance = point.distance_to(Vector2(19, 11))
				furthest_point = point 

		chest_locations.append(furthest_point)
		possible_chest_locations.erase(furthest_point)
			
	var index = 0
	while chest_locations.size() < amount:
		var furthest_point = Vector2.ZERO
		var furthest_distance = 1 
		for point in possible_chest_locations:
			if point.distance_to(chest_locations[index]) > furthest_distance:
				furthest_distance = point.distance_to(chest_locations[index])
				furthest_point = point  

		chest_locations.append(furthest_point)
		possible_chest_locations.erase(furthest_point)
		index += 1
				
	for location in chest_locations:
		var new_chest = GOLDEN_CHEST.instance()
		self.add_child(new_chest)
		new_chest.global_position = tileMap.map_to_world(location)
					
				



func clear_enemies():
	for enemy in enemies.get_children():
		enemy.call_deferred("free")
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
		
func _on_character_died(character_position: Vector2, character: CharacterBody) -> void:
	if character is Player:
		print("player died")
		get_tree().reload_current_scene() 

