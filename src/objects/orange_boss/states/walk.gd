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
	
	var check_dist = speed * delta;
	
	if abs(_actor.position.x - target_x) <= check_dist:
		_actor.position.x = target_x;
		return transition;
	elif abs(_actor.global_position.x - GlobalInfo.player.global_position.x) <= check_dist:
		_actor.position.x = GlobalInfo.player.global_position.x;
		return transition;
	
	_actor.position.x += _velocity_x * delta;
	
	return null;

func process_frame(_delta: float) -> State:
	return null;
