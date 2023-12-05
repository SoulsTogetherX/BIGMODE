extends State

@export var fall : State;
@export var jump : State;
@export var move : State;
@export var slow_down : State;

func get_id():
	return "idle";

func enter() -> void:
	_animationPlayer.play("idle");

func process_physics(_delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		_actor._jump_message();
		_actor.jump_buffer.stop();
		return jump;
	
	if !_actor.is_on_floor():
		return fall;
	
	if _actor.get_movement() != 0:
		return move;
	
	if _actor.velocity.x != 0:
		return slow_down;
	
	return null;
