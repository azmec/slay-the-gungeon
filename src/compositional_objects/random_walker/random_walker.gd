extends Node
class_name Walker

# Standard random walker for level generation.

const DIRECTIONS: Array = [Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1)]
const LONGEST_CORRIDOR: int = 6
const MINIMUM_ROOM_WIDTH = 4
const MINIMUM_ROOM_HEIGHT = 4


var position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT
var borders: Rect2 = Rect2()
var step_history: Array = []
var steps_since_last_turn: int = 0
var spawn_position = Vector2.ZERO

func _init(starting_position: Vector2, new_borders: Rect2) -> void:
	# Here we check if our borders contains the given starting point.
	# If not, we halt the program.
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders 

func walk(steps: int) -> Array:
	create_room(position)
	for step in steps:
		if randf() <= 0.25 or steps_since_last_turn >= LONGEST_CORRIDOR:
			change_direction()
		if step():
			step_history.append(position)
			#step_history.append(position + Vector2.RIGHT)
			#step_history.append(position + Vector2.DOWN)
			#step_history.append(position + Vector2.LEFT)
			#step_history.append(position + Vector2.UP)
			#step_history.append(position + Vector2(1, -1))
			#step_history.append(position + Vector2(-1, -1))
			#step_history.append(position + Vector2(1, 1))
			#step_history.append(position + Vector2(-1, 1))

		else:
			change_direction()
	return step_history

func step() -> bool: 
	# First, we project our target position by
	# creating a point 1 step in a given direction.
	var target_position = position + direction 
	# Then we check this point and proceed if valid, else we return false.
	if borders.has_point(target_position):
		steps_since_last_turn += 1
		position = target_position
		return true
	else:
		return true

func change_direction() -> void:
	create_room(position)
	steps_since_last_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(given_position: Vector2) -> void:
	var size = Vector2(randi() % MINIMUM_ROOM_WIDTH + 2, randi() % MINIMUM_ROOM_HEIGHT + 2)
	var top_left_corner = (given_position - size / 2).ceil()
	for y in size.y: 
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)
