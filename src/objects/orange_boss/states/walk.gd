extends State

@export var fall       : State;
@export var transition : State;

@export var speed     : float = 300;
var _velocity_x : float;
var target_x : float;

func get_id():
	return "walk";

func state_ready() -> void:
	pass;

func enter() -> void:
	_velocity_x = speed * sign(target_x - _actor.position.x);
	
	fall.return_state = self;
	_animationPlayer.play("walk");
	_actor.turn(_velocity_x > 0);

func exit() -> void:
	_actor.velocity.x = 0;

func process_physics(delta: float) -> State:
	if !_actor.on_floor():
		return fall;
	
	if abs(_actor.position.x - target_x) <= speed * delta:
		_actor.position.x = target_x;
		return transition;
	
	_actor.position.x += _velocity_x * delta;
	
	return null;

func process_frame(_delta: float) -> State:
	return null;
