extends State

var gravity : float = 980.0;
var has_jumped : bool = false;

@export var idle : State;
@export var jump : State;
@export var move : State;

@export var wall_jump_speed : float = 500;

var prev_y : float;

func get_id():
	return "fall";

func enter() -> void:
	if !has_jumped:
		_actor.coyote_timer.start();
	_animationPlayer.play("fall");
	prev_y = 0;

func exit() -> void:
	has_jumped = false;

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		var sign_c = sign(_actor.on_wall_right.get_overlapping_bodies().size() - _actor.on_wall_left.get_overlapping_bodies().size());
		if sign_c != 0:
			_actor.velocity.x += -wall_jump_speed * sign_c;
			_actor.turn(sign_c != -1);
			_actor.velocity.y = 0;
			_actor._wall_kick_message();
			return jump;
		elif _actor.coyote_timer.is_stopped():
			_actor.jump_buffer.start();
		elif !has_jumped:
			_actor._coyote_message();
			_actor.jump_buffer.stop();
			return jump;
	
	if has_jumped && !Input.is_action_pressed("jump"):
		if _actor.boosted:
			if _actor.velocity.y < _actor.BOOST_CUTOFF:
				_actor.velocity.y = lerp(_actor.velocity.y, _actor.BOOST_CUTOFF, 0.2);
		else:
			if _actor.velocity.y < _actor.JUMP_CUTOFF:
				_actor.velocity.y = lerp(_actor.velocity.y, _actor.JUMP_CUTOFF, 0.2);
	
	if _actor.is_on_floor():
		if !_actor.jump_buffer.is_stopped():
			_actor._jump_message();
			_actor.jump_buffer.stop();
			return jump;
		else:
			if prev_y > 150:
				_actor.land_sound();
				_actor._land_message();
			if _actor.velocity.x != 0 || _actor.boosted:
				return move;
			return idle;
	
	_actor.velocity.y += _actor.GRAVITY * delta;
	prev_y = _actor.velocity.y;
	
	if _actor.velocity.y > 0:
		_actor.collision_layer |= 16;
	
	_actor._move_hor();
	
	return null;
