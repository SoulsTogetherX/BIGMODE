extends State

@export var attack2 : State;
@export var jump    : State;
@export var transition : State;

func get_id():
	return "cutscene_second_phase";

func enter() -> void:
	transition.state_queue = [
		[Boss.ACTION.JUMP, 0.7, _actor.get_jump_target(false)],
		[Boss.ACTION.ATTACK2, 1.5],
		[Boss.ACTION.JUMP, 0.2, _actor.floor_mid_marker],
	]

func process_physics(_delta: float) -> State:
	return transition;
