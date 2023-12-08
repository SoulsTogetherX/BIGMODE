extends Node2D

var radius : int = 200;

var tween : Tween;

func _draw() -> void:
	draw_circle(Vector2.ZERO, 1, Color("#ff464696"));

func show_danger_shape(fade_time : float) -> void:
	if tween:
		tween.kill();
	tween = create_tween().set_parallel();
	
	scale = Vector2(0, 0);
	modulate.a = 0.0;
	
	tween.tween_property(self, "modulate:a", 1.0, fade_time * 0.5);
	tween.tween_property(self, "scale", Vector2(radius, radius), fade_time * 0.5);

func hide_danger_shape(fade_time : float) -> void:
	if tween:
		tween.kill();
	tween = create_tween();
	
	tween.tween_property(self, "modulate:a", 0.0, fade_time);
