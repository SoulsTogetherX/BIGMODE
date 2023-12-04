extends State

var gravity : float = 980.0;
var has_jumped : bool = false;

@export var idle : State;
@export var jump : State;

func get_id():
	return "fall";

func enter() -> void:
	if !has_jumped:
		_actor.coyote_timer.start();

func exit() -> void:
	_actor.velocity.y = 0;
	has_jumped = false;

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		if _actor.coyote_timer.is_stopped():
			_actor.jump_buffer.start();
		elif !has_jumped:
			_actor.jump_buffer.stop();
			return jump;
	
	if has_jumped && !Input.is_action_pressed("jump") && _actor.velocity.y < _actor.JUMP_CUTOFF:
		_actor.velocity.y = lerp(_actor.velocity.y, _actor.JUMP_CUTOFF, 0.4);
	
	var direction = Input.get_axis("left", "right");
	if _actor.is_on_floor():
		if !_actor.jump_buffer.is_stopped():
			_actor.jump_buffer.stop();
			return jump;
		else:
			return idle;
	
	_actor.velocity.y += _actor.GRAVITY * delta;
	
	return null;
