extends AnimateState

func get_id():
	return "ded";

func get_animation() -> String:
	return "ded";

func enter() -> void:
	_actor.collision_layer = 0;

func exit() -> void:
	_actor.collision_layer = 2;

func process_physics(delta: float) -> State:
	_actor.velocity.x = 0;
	_actor.velocity.y += _actor.GRAVITY * delta;
	return null;

func on_end_animation() -> State:
	GlobalInfo.respawn();
	
	return null;
