extends State

@export var fall : State;
@export var jump : State;
@export var slow_down : State;

func get_id():
	return "move";

func enter() -> void:
	_animationPlayer.play("walk");

func process_physics(_delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		_actor._jump_message();
		_actor.jump_buffer.stop();
		return jump;
	
	if !_actor.is_on_floor():
		return fall;
	
	if !_actor._move_hor(_actor.fix_speed_when_next_on_ground):
		return slow_down;
	
	return null;
