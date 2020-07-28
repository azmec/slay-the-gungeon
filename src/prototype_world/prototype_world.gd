extends Node2D

const SLIME_ENEMY = preload("res://src/character_objects/enemies/slime/slime.tscn")
var borders = Rect2(1, 1, 88, 160)

onready var tileMap = $TileMap 
onready var player = $Player
onready var enemies = $Enemies

func _ready() -> void:
	randomize()
	generate_level()
	spawn_enemies()

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(1500)
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, 0)
	tileMap.update_bitmask_region(borders.position, borders.end)
	player.global_position = tileMap.map_to_world(Vector2(19, 11))
	player.create_deck()
	player.draw_hand()

func spawn_enemies():
	var possible_spawn_locations = tileMap.get_used_cells()
	possible_spawn_locations.shuffle()
	for location in possible_spawn_locations:
		if randf() <= 0.01:
			var slime = SLIME_ENEMY.instance()
			enemies.add_child(slime)
			slime.global_position = tileMap.map_to_world(location)

func clear_enemies():
	for enemy in enemies.get_children():
		enemy.call_deferred("free")
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		clear_enemies()
		player.reset()
		tileMap.clear()
		randomize()
		generate_level()
		spawn_enemies()
		
