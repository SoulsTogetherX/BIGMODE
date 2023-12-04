extends State

@export var _idle : State;

func get_id():
	return "fall";

func enter() -> void:
	_animationPlayer.play("fall");

func process_physics(delta: float) -> State:
	if _actor.is_on_floor():
		return _idle;
	
	_actor.velocity.y += _actor.GRAVITY * delta;
	_actor.move_and_slide();
	
	return null;
