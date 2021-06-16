extends Actor


export var stomp_impulse := 1000.0


func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)


func _on_EnemyDetector_body_entered(body: Node) -> void:
	queue_free()


func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("move_jump")\
		and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = calculate_move_velocity(
		_velocity, direction, speed, is_jump_interrupted
	)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") 
		- Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_pressed("move_jump") and is_on_floor()
		else 1.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var current_velocity := linear_velocity
	current_velocity.x = speed.x * direction.x
	if direction.y == -1.0:
		current_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		current_velocity.y = 0.0
	return current_velocity

func calculate_stomp_velocity(
		linear_velocity: Vector2,
		impulse: float
	) -> Vector2:
		var current_velocity := linear_velocity
		current_velocity.y = -impulse
		return current_velocity
