extends State

var return_state : State;

func get_id():
	return "wall_fall";

func state_ready() -> void:
	pass;

func enter() -> void:
	_animationPlayer.play("fall");

func exit() -> void:
	_actor.velocity.y = 0;

func process_physics(delta: float) -> State:
	if _actor.on_floor():
		return return_state;
	
	_actor.velocity.y += _actor.GRAVITY * delta;
	_actor.move_and_slide();
	
	return null;

func process_frame(_delta: float) -> State:
	return null;

