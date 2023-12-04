extends State

@export var fall : State;

func get_id():
	return "idle";

func enter() -> void:
	if !_actor.move:
		_animationPlayer.play("idle");
	else:
		_animationPlayer.play("walk");

func process_physics(_delta: float) -> State:
	if !_actor.is_on_floor():
		return fall;
	
	return null;
