extends State

@export var move : State;

func get_id():
	return "idle";

func enter() -> void:
	_animationPlayer.play("idle");

func process_physics(_delta: float) -> State:
	if _actor.get_movement() != 0:
		return move;
	return null;
