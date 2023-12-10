extends State

var gravity : float = 980.0;
var start_jump_speed : float = 100;
var jump_speed : float;

@export var fall : State;
@export var idle : State;

func get_id():
	return "jump";

func enter() -> void:
	_actor.coyote_timer.stop();
	_actor.jump_buffer.stop();
	fall.has_jumped = true;
	
	_animationPlayer.play("jump");
	if _actor.boosted:
		_actor.velocity.y += _actor.BOOST_JUMP;
	else:
		_actor.velocity.y += _actor.JUMP_VELOCITY;

func exit() -> void:
	_actor.force_jumped = false;

func process_physics(delta: float) -> State:
	if _actor.is_on_floor():
		return fall;
	
	if Input.is_action_just_released("jump"):
		_actor.velocity.y *= 0.5;
		return fall;
	
	_actor.velocity.y += _actor.GRAVITY * delta;
	if _actor.velocity.y > 0:
		return fall;
	
	_actor._move_hor();
	
	return null;
