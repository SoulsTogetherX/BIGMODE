extends AnimateState

func get_id():
	return "ded";

func get_animation() -> String:
	return "ded";

func enter() -> void:
	_actor.collision_layer = 0;

func exit() -> void:
	_actor.collision_layer = 2;

func on_end_animation() -> State:
	return null;
