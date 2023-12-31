extends State

@export var fall : State;
@export var idle : State;

func get_id():
	return "walk";

func enter() -> void:
	_actor.velocity = Vector2(_actor.move_speed * (-1 if _actor.face_left else 1), 0);
	_animationPlayer.play("walk");

func process_physics(_delta: float) -> State:
	if !_actor.fall_move && _actor.fall_detect.get_overlapping_bodies().size() == 0:
		turn();
	elif _actor.forward_detect.get_overlapping_bodies().size() > 0:
		turn();
	if !_actor.is_on_floor():
		return fall;
	
	_actor.move_and_slide();
	
	return null;

func turn() -> void:
	_actor.face_left = !_actor.face_left;
	_actor.velocity = Vector2(_actor.move_speed * (-1 if _actor.face_left else 1), 0);
