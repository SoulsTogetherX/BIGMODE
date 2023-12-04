extends State

@export var slow_down : State;

func get_id():
	return "move";

func enter() -> void:
	_animationPlayer.play("walk");

func process_physics(_delta: float) -> State:
	var move : float = _actor.get_movement();
	if move == 0:
		return slow_down;
	_actor.velocity.x = move * _actor.SPEED;
	_actor.turn(_actor.velocity.x < 0);
	
	return null;
