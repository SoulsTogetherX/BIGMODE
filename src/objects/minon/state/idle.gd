extends State

@export var move : State;
@export var fall : State;

func get_id():
	return "idle";

func enter() -> void:
	_animationPlayer.play("idle");

func process_physics(_delta: float) -> State:
	if _actor.move:
		return move;
	
	if !_actor.is_on_floor():
		return fall;
	
	return null;
