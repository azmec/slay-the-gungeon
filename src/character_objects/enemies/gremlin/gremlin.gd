extends EnemyBody 

# Gremlin creature that attacks the player with sporadic
# arrow shots. See class EnemyBody for particular variables
# that are not declared here.  

enum {
	IDLE, 
	WANDER, 
	CHASE, 
	STAGGER,
	SHOOT
} 

const ARROW_SHOT = preload("res://src/compositional_objects/bullets/enemy_arrow_shot/enemy_arrow_shot.tscn")
var state: int = 0  

onready var shotTimer = $ShotTimer 

func _init():
	MAX_SPEED = 50

func _ready():
	state = _pick_random_state([IDLE, WANDER]) 

func _physics_process(delta: float) -> void: 
	match state:
		IDLE:
			idle(delta)
		WANDER:
			wander(delta)
		CHASE: 
			chase(delta) 
		STAGGER: 
			stagger(delta) 
	velocity = move_and_slide(velocity) 

	
func idle(delta: float) -> void:
	animationPlayer.play("idle") 
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 
	if playerDetector.can_see_player():
		state = CHASE 
	if wanderController.get_time_left() == 0:
		_update_wander()

func wander(delta: float) -> void:
	animationPlayer.play("run") 
	if playerDetector.can_see_player():
		state = CHASE 
	var wander_direction = self.global_position.direction_to(wanderController.target_position)
	velocity = velocity.move_toward(wander_direction * MAX_SPEED, ACCELERATION * delta) 
	if self.global_position.distance_to(wanderController.target_position) <= 4:
		_update_wander() 
	
func chase(delta: float) -> void:
	if playerDetector.can_see_player():
		animationPlayer.play("run")  
		var player = playerDetector.player
		var direction_to_player = self.global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta) 
		shoot(direction_to_player)
	else:
		state = IDLE

func stagger(delta: float) -> void: 
	animationPlayer.play("hurt")  
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 

func shoot(direction: Vector2):
	if shotTimer.is_stopped():
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * get_physics_process_delta_time())
		var new_shot = ARROW_SHOT.instance()
		get_parent().add_child(new_shot) 
		new_shot.spawn(self.global_position, direction) 
		$Sounds/Shoot.play()
		shotTimer.start(rand_range(0.5, 2))

func _update_wander() -> void:
	state = _pick_random_state([IDLE, WANDER]) 
	wanderController.start_wander_timer(rand_range(1, 3)) 

func _pick_random_state(state_list: Array) -> int:
	state_list.shuffle() 
	return state_list.pop_front() 

func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void:
	state = STAGGER 
	$Sounds/Hurt.play()
	._on_damage_taken(damage, knockback, infliction)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "hurt":
		state = IDLE 
