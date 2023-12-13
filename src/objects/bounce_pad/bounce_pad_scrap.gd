@tool
extends Node2D

var tween : Tween;

var _actor : Node2D;
var _start : Vector2;
var _control : Vector2;

@export var _end : Vector2:
	set(val):
		_end = val;
		queue_redraw();

@export var arc_height : float = 100:
	set(val):
		arc_height = val;
		queue_redraw();

@export var segment_draw : int = 100:
	set(val):
		segment_draw = val;
		queue_redraw();

@export var time : float = 0.5;

func _draw() -> void:
	if Engine.is_editor_hint():
		_draw_arc();

func _ready() -> void:
	if !Engine.is_editor_hint():
		_end = to_global(_end);

func _draw_arc() -> void:
	_start = Vector2.ZERO;
	_control = _start + ((_end - _start) * 0.5) + (Vector2.UP * arc_height);
	
	var prev : Vector2 = _start;
	for i in (segment_draw):
		var gradient = float(i + 1) / segment_draw;
		
		var lerp1   : Vector2 = lerp(_start, _control, gradient);
		var lerp2   : Vector2 = lerp(_control, _end, gradient);
		var new_pos : Vector2 = lerp(lerp1, lerp2, gradient);

		draw_line(prev, new_pos, Color.CRIMSON);
		prev = new_pos;

func _on_enter(body: Node2D) -> void:
	_actor = body;
	_actor.body_overhead.change_state("main", "fall");
	
	_start = _actor.global_position;
	_control = _start + ((_end - _start) * 0.5) + (Vector2.UP * arc_height);
	
	if tween:
		tween.kill();
	
	_actor.pause_physics = true;
	tween = create_tween();
	tween.tween_method(_arc_shoot, 0.0, 1.0, time);
	tween.tween_property(_actor, "pause_physics", false, 0.01);

func _arc_shoot(gradient : float) -> void:
	var lerp1   : Vector2 = lerp(_start, _control, gradient);
	var lerp2   : Vector2 = lerp(_control, _end, gradient);
	var new_pos : Vector2 = lerp(lerp1, lerp2, gradient);
	GlobalInfo.player.global_position = new_pos;
