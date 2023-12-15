extends AnimateState

var base_x_pos : float;
var shakey : bool;

func get_id():
	return "ded";

func get_animation() -> String:
	return "ded";

func enter() -> void:
	GlobalInfo.camera.shake_event(Vector3(1, 1, 0.0), Vector3(7., 7., 0), Vector3(0.2, 0.2, 0));
	
	lock = true;
	
	shakey = false;
	await get_tree().create_timer(5.5).timeout;
	
	base_x_pos = _actor.global_position.x;
	shakey = true;
	
	await get_tree().create_timer(1.875).timeout;
	shakey = false;
	_actor.smoke_particle.fade_this();
	
	await get_tree().create_timer(1).timeout;
	_actor.light_manager.fade_lights();
	
	await get_tree().create_timer(1).timeout;
	GlobalInfo.player.force_victory();

func process_frame(_delta: float) -> State:
	if shakey:
		_actor.global_position.x = base_x_pos + (randf() * 10 - 5);
	return null;

func on_end_animation() -> State:
	return null;

