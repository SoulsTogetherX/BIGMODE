extends State

@export var _move : State;
@export var _idle : State;

func get_id():
	return "transition";

func process_frame(_delta: float) -> State:
	if _actor.move:
		return _move;
	return _idle;
