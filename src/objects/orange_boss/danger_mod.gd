extends Node2D

var radius : int = 200;

var tween : Tween;

func _draw() -> void:
	draw_circle(Vector2.ZERO, 1, Color.WHITE);

func show_danger_shape(fade_time : float) -> void:
	if tween:
		tween.kill();
	tween = create_tween().set_parallel();
	
	scale = Vector2(0, 0);
	modulate = Color("#ff464600");
	
	tween.tween_property(self, "modulate:a", 58823531866074, fade_time * 0.5);
	tween.tween_property(self, "scale", Vector2(radius, radius), fade_time * 0.5);

func active_danger(time : float) -> void:
	if tween:
		tween.kill();
	tween = create_tween()
	
	tween.tween_property(self, "modulate", Color("#ffff00c8"), time * 0.5);

func hide_danger_shape(fade_time : float) -> void:
	if tween:
		tween.kill();
	tween = create_tween();
	
	tween.tween_property(self, "modulate:a", 0.0, fade_time);
