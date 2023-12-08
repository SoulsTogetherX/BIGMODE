extends State

@export var transition : State;
@export var arc_height : float = 500;
@export var speed      : float = 1.2;

var target     : Marker2D;
var _start     : Vector2;
var _end       : Vector2;
var _control   : Vector2;
var jump_tween : Tween;

func get_id():
	return "jump";

func state_ready() -> void:
	pass;

func enter() -> void:
	_animationPlayer.play("jump");
	
	_start = _actor.position;
	_end = target.position;
	_control = _start + ((_end - _start) * 0.5) + (Vector2.UP * arc_height)
	
	jump_tween = create_tween();
	jump_tween.tween_method(_arc_shoot.bind(), 0.0, 1.0, speed);
	jump_tween.tween_callback(get_parent()._change_state.bind(transition));

func exit() -> void:
	_actor.global_position.y = target.global_position.y;

func process_physics(_delta: float) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func _arc_shoot(gradient : float) -> void:
	var lerp1   : Vector2 = lerp(_start, _control, gradient);
	var lerp2   : Vector2 = lerp(_control, _end, gradient);
	var new_pos : Vector2 = lerp(lerp1, lerp2, gradient);
	_actor.global_position = new_pos;
	
	_actor.turn(GlobalInfo.player.global_position > new_pos);
