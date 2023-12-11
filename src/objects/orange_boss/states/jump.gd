extends State

@export var transition : State;
@export var arc_height : float = 500;
@export var speed      : float = 1.2;

@onready var land_emitter: Emitter = $"../../../Sprite2D/land_emitter"

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
	
	await get_tree().create_timer(0.3).timeout;
	
	_start = _actor.position;
	_end = target.position;
	_control = _start + ((_end - _start) * 0.5) + (Vector2.UP * arc_height)
	
	jump_tween = create_tween();
	jump_tween.tween_method(_arc_shoot.bind(), 0.0, 1.0, speed);
	jump_tween.tween_callback(end_state);

func exit() -> void:
	_actor.global_position.y = target.global_position.y;
	_animationPlayer.play("idle");
	land_emitter.play_random();
	
	if jump_tween:
		var pos = _actor.global_position;
		jump_tween.kill();
		_actor.global_position = pos;

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

func end_state() -> void:
	_actor.global_position.y = _actor.find_floor();
	
	if _actor.wave_jump:
		_actor.create_shockwave();
	get_parent()._change_state(transition)
