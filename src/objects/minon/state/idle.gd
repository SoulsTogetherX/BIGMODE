extends State

@export var move : State;
@export var fall : State;

func get_id():
	return "idle";

func enter() -> void:
	_animationPlayer.play("idle");
	if _actor.move:
		get_parent()._change_state(move)
