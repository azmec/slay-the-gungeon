class_name LevelGenerator
extends Node

const GOLDEN_CHEST = preload("res://src/items/golden_chest/golden_chest.tscn")
const NORMAL_CHEST = preload("res://src/items/normal_chest/normal_chest.tscn")

var enemy_pool = []
var steps_to_take: int = 0 
var wallTileMap: TileMap 
var floorTileMap: Sprite 
var difficulty: int = 1
var level_borders: Rect2
var spawn_point: Vector2 = Vector2.ZERO 
var floor_map: Array = []

func _init(spawn: Vector2, steps: int, borders: Rect2, diff: int, enemies: Array, wallTiles: TileMap, floorTiles: Sprite):
	self.spawn_point = spawn 
	self.steps_to_take = steps 
	self.level_borders = borders
	self.difficulty = diff
	self.enemy_pool = enemies 
	self.wallTileMap = wallTiles 
	self.floorTileMap = floorTiles

func generate_level(player: Player) -> void:
	var walker = Walker.new(spawn_point, level_borders)
	floor_map = walker.walk(steps_to_take) 
	walker.queue_free() 

	fill_borders(level_borders)
	map_floor(floor_map, level_borders)
	player.global_position = wallTileMap.map_to_world(spawn_point)
	spawn_enemies(floor_map, enemy_pool, difficulty, player)
	spawn_prop(floor_map, GOLDEN_CHEST)
	spawn_prop(floor_map, NORMAL_CHEST)

func fill_borders(borders: Rect2) -> void:
	for x in borders.end.x:
		for y in borders.end.y:
			wallTileMap.set_cellv(Vector2(x, y), 0)

func map_floor(walker_steps: Array, borders: Rect2) -> void:
	for location in walker_steps:
		wallTileMap.set_cellv(location, -1) 

	var tile_rect = wallTileMap.get_used_rect()
	var top_left = wallTileMap.map_to_world(tile_rect.position)
	var size = wallTileMap.map_to_world(tile_rect.size)
	floorTileMap.region_rect = Rect2(0, 0, size.x, size.y)
	wallTileMap.update_bitmask_region()
	
func spawn_enemies(spawn_locations: Array, enemies: Array, diff: int, player: Player) -> void:
	var enemies_to_spawn = diff * 10 + randi() % (diff * 2)
	var spawned_enemies = 0
	
	for location in spawn_locations:
		if location.distance_to(spawn_point) < 15 or spawned_enemies >= enemies_to_spawn:
			continue
		if randf() < 0.006:
			var new_enemy = enemies[randi() % enemies.size()].instance()
			add_child(new_enemy) 
			new_enemy.global_position = wallTileMap.map_to_world(location) 
			spawned_enemies += 1 

func spawn_prop(spawn_locations: Array, prop) -> void:
	var furthest_distance = 1
	var furthest_point = spawn_point 
	var prop_spawn_locations = [] 

	for location in spawn_locations:
		if randf() < 0.006:
			prop_spawn_locations.append(location) 

	for location in prop_spawn_locations:
		if location.distance_to(spawn_point) > furthest_distance:
			furthest_distance = location.distance_to(spawn_point) 
			furthest_point = location 

	var new_prop = prop.instance() 
	add_child(new_prop)
	new_prop.global_position = wallTileMap.map_to_world(furthest_point)
	
