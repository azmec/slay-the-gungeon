extends EnemyBody

# Standard slime enemy. To move, the slime jumps and lands, producing some bullets upon
# impact. As such, the way it chooses to move is it picks a position in a radius, and moves there.
# As it moves, it will enter the "jump" animation. Once it's more or less at the target point,
# it will "land". 

enum {
	IDLE,
	WANDER,
	CHASE,
	STAGGER
}

var state: int = 0

func _init():
	MAX_SPEED = 70
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
	pass

func wander(delta: float) -> void:
	pass

func chase(delta:float) -> void:
	pass
func stagger(delta:float) -> void:
	animationPlayer.play("hurt")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

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
