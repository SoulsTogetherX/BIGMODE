extends State

@export var _shoot : State;

func get_id():
	return "idle";

func enter() -> void:
	_animationPlayer.play("idle");

func reposition_gun() -> void:
	var target : Vector2 = _actor.davids_gun.get_global_mouse_position();
	var dir = sign(_actor.davids_gun.get_parent().scale.x);
	var angle : float = rad_to_deg(_actor.davids_gun.global_position.angle_to_point(target));
	if dir == 1:
		if abs(angle) > 60:
			return;
	elif abs(angle) < 120:
		return;
	
	_actor.davids_gun.global_rotation_degrees = angle;

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("shoot"):
		return _shoot;
	
	reposition_gun();
	return null;
