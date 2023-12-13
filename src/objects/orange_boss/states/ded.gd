extends AnimateState

var base_x_pos : float;
var shakey : bool;

func get_id():
	return "ded";

func get_animation() -> String:
	return "ded";

func enter() -> void:
	lock = true;
	base_x_pos = _actor.global_position.x;
	
	shakey = false;
	await get_tree().create_timer(5.5).timeout;
	shakey = true;
	await get_tree().create_timer(1.875).timeout;
	shakey = false;
	
	await get_tree().create_timer(2).timeout;
	GlobalInfo.player.force_victory();

func process_frame(delta: float) -> State:
	if shakey:
		_actor.global_position.x = base_x_pos + (randf() * 10 - 5);
	return null;

func on_end_animation() -> State:
	return null;

