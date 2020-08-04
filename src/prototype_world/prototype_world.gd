extends Node2D

const GREMLIN_ENEMY = preload("res://src/character_objects/enemies/gremlin/gremlin.tscn") 
const SLIME_ENEMY = preload("res://src/character_objects/enemies/slime/slime.tscn")
const MANA_DROP = preload("res://src/compositional_objects/mana_drop/mana_drop.tscn") 

var borders = Rect2(1, 1, 160, 80)
var level_points: Array
onready var tileMap = $TileMap 
onready var player = $Player
onready var enemies = $Enemies


func _ready() -> void:
	randomize()
	generate_level()
	spawn_enemies()
	#BGMController.play_new_track("res://assets/bgm/musBoss1.ogg")

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
		if randf() <= 0.01:
			var enemy = SLIME_ENEMY.instance()
			if randf() <= 0.5:
				enemy = GREMLIN_ENEMY.instance()
			enemies.add_child(enemy)
			enemy.global_position = tileMap.map_to_world(point) 
			if enemy.global_position.distance_to(player.global_position) <= 200:
				enemy.queue_free()	 

	for character in get_tree().get_nodes_in_group("characters"):
		character.connect("character_died", self, "_on_character_died", [character])

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

	if character is EnemyBody:
		player.camera.trauma += character.healthStats.max_health * 0.1 
		if player.mana == player.max_mana:
			return
		var mana_drops = randi() % 4 + 1 
		if mana_drops <= 0:
			var drop = MANA_DROP.instance()
			call_deferred("add_child", drop)
			drop.global_position = character_position
		else:
			for mana_drop in mana_drops:
				var drop = MANA_DROP.instance()
				call_deferred("add_child", drop)
				drop.global_position = character_position

