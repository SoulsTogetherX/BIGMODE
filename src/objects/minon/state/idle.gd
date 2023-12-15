extends State

@export var move : State;

func get_id():
	return "idle";

func enter() -> void:
	_animationPlayer.play("idle");

func process_frame(_delta: float) -> State:
	if _actor.move:
		get_parent()._change_state(move);
	
	return null;
