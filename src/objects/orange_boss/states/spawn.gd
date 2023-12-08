extends State

@export var transition : State;

func get_id():
	return "spawn";

func enter() -> void:
	_actor.spawn_minons();

func process_frame(_delta: float) -> State:
	return transition;

