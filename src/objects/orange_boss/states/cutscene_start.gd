extends State

@export var transition : State;

func get_id():
	return "cutscene_start";

func state_ready() -> void:
	pass;

func enter() -> void:
	pass;

func exit() -> void:
	pass;

func process_physics(_delta: float) -> State:
	if GlobalInfo.player.is_inside_tree():
		return transition;
	
	return null;

func process_frame(_delta: float) -> State:
	return null;

