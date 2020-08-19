extends BossBody 

# For this boss, I want to emulate the Blob King shit from
# EtG. The SLime King will have two attacks: A ring that propels
# outward and a series of bullets that follow the player. 

enum {
	IDLE,
	RING,
	SERIES,
	DEAD
} 

const BULLET = preload("res://src/compositional_objects/bullets/slime_bullet/slime_bullet.tscn")
const FIRERATE = 0.1

var state = 0
var fired: bool = false

onready var firingAxis = $FiringAxis
onready var firingPoint = $FiringAxis/FiringPoint
onready var firerateTimer = $FirerateTimer

func _init() -> void:
	MAX_SPEED = 10 
	boss_name = "SLIME KING"

func _ready() -> void:
	state = IDLE

func _physics_process(delta: float) -> void:
	match state:
		IDLE: 
			idle(delta)
		RING:
			ring(delta)
		SERIES:
			series(delta) 
		DEAD:
			dead(delta)
			
	velocity = move_and_slide(velocity)

# During this state, motion comes to a stop. If we see the player,
# we will wait some random amount of seconds and pick a random attack.
func idle(delta: float) -> void:
	# Wait random amount of seconds
	# after these seconds, randomly pick a state 
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if playerDetector.can_see_player():
		start_wait_timer()

# This state forces the boss to fire a ring of bullets around itself 
# for a random amount of waves. After firing, it will wait and select 
# another random attack.
func ring(delta: float) -> void:
	
	if not fired:
		_setup_ring_state(50)
		fired = true

	if playerDetector.can_see_player():
		var player = playerDetector.player 
		var direction_to_player = self.global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta)
	
	start_wait_timer()

# Similar to RING, except it simply fires in the direction of the player.
func series(delta: float) -> void:
	if playerDetector.can_see_player() and firerateTimer.is_stopped():
		var player = playerDetector.player 
		var direction_to_player = self.global_position.direction_to(player.global_position)
		print(direction_to_player)
		var new_bullet = BULLET.instance() 
		get_parent().add_child(new_bullet) 
		new_bullet.spawn(firingPoint.global_position, direction_to_player)
		velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta)
		firerateTimer.start(FIRERATE) 

	start_wait_timer()

# Motion comes to a stop.
func dead(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func start_wait_timer() -> void:
	if !waitTimer.is_stopped(): return 

	var random_number = randi() % 3 + 1
	waitTimer.start(random_number) 

func _setup_ring_state(bullets_to_fire: int) -> void:
	firingAxis.rotation_degrees = randi() % 180 

	var degrees_between_bullets = 360 / bullets_to_fire 
	print(degrees_between_bullets)
	for bullet in bullets_to_fire:
		var new_bullet = BULLET.instance()
		get_parent().add_child(new_bullet) 
		new_bullet.spawn(firingPoint.global_position, firingAxis.global_position.direction_to(firingPoint.global_position))
		firingAxis.rotation_degrees += degrees_between_bullets 

func _pick_random_state(state_list: Array) -> int:
	state_list.shuffle()
	return state_list.pop_front()

func _on_waitTimer_timeout() -> void:
	print("Wait timer timeout.")
	fired = false
	state = _pick_random_state([RING, SERIES])

func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void:
	animationPlayer.play("hurt") 
	._on_damage_taken(damage, knockback, infliction)

func _on_no_health() -> void:
	waitTimer.stop()
	hurtbox.set_deferred("monitorable", false)
	hurtbox.set_deferred("monitoring", false) 
	hitbox.set_deferred("monitorable", false)
	sprite.play("death")
	state = DEAD 
	._on_no_health()