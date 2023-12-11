extends State

@export var _shoot : State;

@onready var shoot_timer: Timer = $"../../../shoot_timer"

func get_id():
	return "idle";

func state_ready() -> void:
	shoot_timer.timeout.connect(force_shoot);

func enter() -> void:
	_animationPlayer.play("idle");

func reposition_gun() -> void:
	var target : Vector2;
	var look_vec = _actor.get_look();
	if look_vec == Vector2(0,0):
		target = _actor.davids_gun.get_global_mouse_position();
	else:
		target = look_vec + _actor.davids_gun.global_position;
	
	var dir = sign(_actor.davids_gun.get_parent().scale.x);
	var angle : float = rad_to_deg(_actor.davids_gun.global_position.angle_to_point(target));
	if dir == 1:
		if abs(angle) > 70:
			return;
	elif abs(angle) < 110:
		return;
	
	_actor.davids_gun.global_rotation_degrees = angle;

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("shoot", true):
		shoot_timer.start();
		return _shoot;
	if Input.is_action_just_released("shoot", true):
		shoot_timer.stop();
	
	reposition_gun();
	return null;

func force_shoot() -> void:
	_stateOverhead.change_state("main", "shoot");
