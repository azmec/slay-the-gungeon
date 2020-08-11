extends EnemyBody

# Standard slime enemy. To move, the slime jumps and lands, producing some bullets upon
# impact. As such, the way it chooses to move is it picks a position in a radius, and moves there.
# As it moves, it will enter the "jump" animation. Once it's more or less at the target point,
# it will "land". 

enum {
	IDLE,
	JUMP,
	LAND,
	CHASE,
	STAGGER,
	DEAD
}

const BULLET = preload("res://src/compositional_objects/bullets/slime_bullet/slime_bullet.tscn")
var state: int = 0

func _init():
	MAX_SPEED = 400
	ACCELERATION = 400
func _ready() -> void:
	state = _pick_random_state([JUMP, IDLE])

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			idle(delta)
		JUMP:
			jump(delta) 
		LAND:
			land(delta)
		CHASE: 
			chase(delta)
		STAGGER:
			stagger(delta)
		DEAD:
			dead(delta)
	velocity = move_and_slide(velocity)

func idle(delta: float) -> void:
	animationPlayer.play("idle")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	_update_wander()
	if playerDetector.can_see_player():
		state = CHASE

func jump(delta: float) -> void:
	var target_point = to_local(wanderController.target_position)
	var direction_vector = self.global_position.direction_to(target_point)
	velocity = velocity.move_toward(direction_vector * MAX_SPEED, ACCELERATION * delta)
	animationPlayer.play("jump")

func land(delta: float) -> void:
	animationPlayer.play("land")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func chase(delta:float) -> void:
	if playerDetector.can_see_player():
		var player = playerDetector.player
		var direction_vector = self.global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_vector * MAX_SPEED, ACCELERATION * delta)
		animationPlayer.play("jump") 
	else:
		state = IDLE 

func stagger(delta:float) -> void:
	animationPlayer.play("hurt")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func dead(delta: float) -> void:
	animationPlayer.play("dead")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 

func _update_wander() -> void:
	state = _pick_random_state([IDLE, JUMP]) 
	wanderController.start_wander_timer(rand_range(1, 3))  

func _pick_random_state(state_list: Array) -> int:
	state_list.shuffle() 
	return state_list.pop_front()  

func _on_no_health() -> void:
	state = DEAD
	self.scale = Vector2(1, 1) 
	do_soft_collisions = false
	healthBar.visible = false
	hitbox.set_deferred("monitorable", false)
	hurtbox.set_deferred("monitorable", false)
	hurtbox.set_deferred("monitoring", false)
	self.modulate = Color(0.5, 0.5, 0.5, 1)
	._on_no_health() 

func _on_damage_taken(damage: int, knockback: Vector2, infliction: String) -> void:
	state = STAGGER
	$Sounds/Hurt.play()
	._on_damage_taken(damage, knockback, infliction) 

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "jump":
		if state == CHASE:
			var new_bullet = BULLET.instance()
			get_parent().add_child(new_bullet) 
			new_bullet.spawn(self.global_position, self.velocity)
		$Sounds/Impact.play()
		state = LAND 
	elif anim_name == "land":
		state = IDLE
	elif anim_name == "hurt":
		state = IDLE
