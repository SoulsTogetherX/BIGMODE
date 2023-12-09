extends State

@export var transition : State;

func get_id():
	return "idle";

func enter() -> void:
	_animationPlayer.play("idle");

func exit() -> void:
	pass;

func process_physics(_delta: float) -> State:
	return transition;

func process_frame(_delta: float) -> State:
	return null;
