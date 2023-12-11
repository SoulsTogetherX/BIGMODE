extends State

var gravity : float = 980.0;
var _friction : float = 2000.;
var _speed    : float;

func get_id():
	return "cutscene";

func enter() -> void:
	_animationPlayer.play("idle");

func process_physics(delta: float) -> State:
	if !_actor.is_on_floor():
		_actor.velocity.y += _actor.GRAVITY * delta;
	
	_speed -= delta * _friction;
	if _speed <= 0:
		_actor.velocity.x = 0;
	else:
		_actor.velocity.x = _speed * sign(_actor.velocity.x);
	
	return null;
