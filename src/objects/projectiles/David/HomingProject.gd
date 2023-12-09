class_name HomingProject extends Projectile

@export var drag_factor  : float = 0.07;

@onready var home_check : Area2D  = $HomeCheck

var _target : Node2D = null;
var _current_velocity : Vector2 = Vector2.ZERO;
var _speed : float = 0.0;

func set_starting_velocity(angle : float, spd : float) -> void:
	rotation = angle;
	_speed = spd;
	
	_current_velocity = Vector2.RIGHT.rotated(rotation).normalized() * spd;

func _move_to(delta : float) -> void:
	var direction : Vector2;
	if _target == null:
		direction = Vector2.RIGHT.rotated(rotation).normalized();
	else:
		direction = global_position.direction_to(_target.global_position).normalized();
	var desired_velocity : Vector2 = direction * _speed;
	
	var change = (desired_velocity - _current_velocity) * drag_factor;
	
	_current_velocity += change;
	look_at(global_position + _current_velocity);
	
	position += _current_velocity * delta;

func on_collide(collide : Node2D) -> void:
	if collide is Minon || collide is Boss:
		collide.shot_at();
	destroy();

func _on_home_check_body_entered(body: Node2D) -> void:
	if body == null || _target != null:
		return;
	_target = body;
