extends EnemyBody

# Standard slime enemy. Will chase towards player if in 
# detection zone. Else, it will wander. 

enum {
	IDLE,
	WANDER,
	CHASE,
	STAGGER
}

var state: int = 0

func _ready() -> void:
	state = _pick_random_state([WANDER, IDLE])

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

func wander(delta: float) -> void:
	animationPlayer.play("run") 
	if playerDetector.can_see_player():
		state = CHASE 
	var wander_direction = self.global_position.direction_to(wanderController.target_position)
	velocity = velocity.move_toward(wander_direction * MAX_SPEED, ACCELERATION * delta) 
	if self.global_position.distance_to(wanderController.target_position) <= 4:
		_update_wander() 

func chase(delta:float) -> void:
	if playerDetector.can_see_player():
		animationPlayer.play("run")
		var player = playerDetector.player
		var direction_to_player = self.global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta)
	else:
		state = IDLE
	
func stagger(delta:float) -> void:
	animationPlayer.play("hurt")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func _update_wander() -> void:
	state = _pick_random_state([IDLE, WANDER]) 
	wanderController.start_wander_timer(rand_range(1, 3))  

func _pick_random_state(state_list: Array) -> int:
	state_list.shuffle() 
	return state_list.pop_front()  

func _on_damage_taken(damage: int, knockback: Vector2) -> void:
	state = STAGGER
	._on_damage_taken(damage, knockback) 

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "hurt":
		state = IDLE
