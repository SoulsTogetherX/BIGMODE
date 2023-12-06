extends Area2D

@export var slow_down : bool = false;

func _on_player_enter(body: Node2D) -> void:
	body.rotation = 0;
	var tw = create_tween();
	
	if slow_down:
		TimeManager.instant_time_scale(0.1, 0.8);
		GlobalInfo.camera.zoom_event(Vector2(0.1, 0.1), Vector2(2, 2));
		
	tw.tween_property(body, "rotation_degrees", 360 * sign(body.velocity.x), 0.4);
	await get_tree().create_timer(0.4).timeout;
	
	if slow_down:
		GlobalInfo.camera.zoom_event(Vector2(0.2, 0.2), Vector2(1, 1));
	body.rotation = 0;
