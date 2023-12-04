extends State

@export var idle : State;
@export var move : State;

var _friction : float = 500.;
var _speed    : float;

func get_id():
	return "slow_down";

func enter() -> void:
	_speed = _actor.SPEED * sign(_actor.get_movement());

func process_physics(_delta: float) -> State:
	if _actor.get_movement() != 0:
		return move;
	
	_speed -= _delta * _friction;
	if _speed <= 0:
		_actor.velocity.x = 0;
		return idle;
	
	_actor.velocity.x = _speed;
	
	return null;
