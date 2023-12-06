extends State

var gravity : float = 980.0;
var has_jumped : bool = false;

@export var idle : State;
@export var jump : State;
@export var move : State;

@export var wall_jump_speed : float = 500;

func get_id():
	return "fall";

func enter() -> void:
	if !has_jumped:
		_actor.coyote_timer.start();
	_animationPlayer.play("fall");

func exit() -> void:
	has_jumped = false;

func process_physics(delta: float) -> State:
	var direction = Input.get_axis("left", "right");
	
	if Input.is_action_just_pressed("jump"):
		if direction != 0 && _actor.on_wall.get_overlapping_bodies().size() > 0:
			_actor.velocity.x += -wall_jump_speed * sign(_actor.turn_node.scale.x);
			_actor.turn(_actor.velocity.x > 0);
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
			$"../../../land".play_random();
			if _actor.velocity.x != 0 || _actor.boosted:
				return move;
			return idle;
	
	_actor.velocity.y += _actor.GRAVITY * delta;
	
	_actor._move_hor();
	
	return null;
