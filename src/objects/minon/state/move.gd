extends State

func get_id():
	return "walk";

func enter() -> void:
	_actor.velocity = Vector2(_actor.move_speed * (1 if _actor.face_left else -1), 0);

func process_physics(_delta: float) -> State:
	if _actor.forward_detect.is_colliding():
		turn();
	if !_actor.fall_detect.is_colliding() && !_actor.fall_move:
		turn();
	
	_actor.move_and_slide();
	
	return null;

func turn() -> void:
	_actor.turn(!_actor.face_left);
	_actor.velocity.x *= -1;
