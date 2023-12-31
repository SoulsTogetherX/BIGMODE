extends State

@export var bullet          : PackedScene;
@export var bullet_speed    : float = 0.0;
@export var fall_back_speed : float = 0.0;
@export var kickback        : float = 0.0;

@export var _idle : State;

@onready var shoot_timer: Timer = $"../../../shoot_timer";

func get_id():
	return "shoot";

func enter() -> void:
	_animationPlayer.play("shoot");

func process_frame(_delta: float) -> State:
	_actor.turn(_actor.get_local_mouse_position().x < 0);
	_idle.reposition_gun();
	
	var bullet_ : HomingProject = bullet.instantiate();
	get_tree().current_scene.add_child(bullet_);
	
	var shoot_pos = _actor.davids_gun.get_node("shoot_pos");
	bullet_.global_position = shoot_pos.global_position;
	
	var velocity : Vector2 = Vector2.RIGHT.rotated(_actor.davids_gun.global_rotation) * bullet_speed;
	var norm : Vector2 = velocity.normalized();
	
	if abs(velocity.x) < abs(_actor.velocity.x) && sign(velocity.x) != sign(_actor.velocity.x):
		velocity.x = norm.x * fall_back_speed;
	else:
		velocity.x += _actor.velocity.x;
	
	if abs(velocity.y) < abs(_actor.velocity.y) && sign(velocity.y) != sign(_actor.velocity.y):
		velocity.y = norm.y * fall_back_speed;
	else:
		velocity.y += _actor.velocity.y;
	
	bullet_.set_starting_velocity(velocity.angle(), velocity.length());
	bullet_.set_timer(2.5);
	
	if _actor.turn_node.scale.x:
		_actor.velocity -= Vector2.RIGHT\
							.rotated(_actor.davids_gun.global_rotation)\
							* kickback;
		
	_actor.fix_speed_when_next_on_ground = true;
	_actor._shoot_message(\
						bullet_.global_position +\
						Vector2(sign(_actor.get_local_mouse_position().x)\
						* 20, -30)\
						);
	
	_actor.gun_sound();
	
	if Input.is_action_pressed("shoot", true):
		shoot_timer.start();
	
	return _idle;
