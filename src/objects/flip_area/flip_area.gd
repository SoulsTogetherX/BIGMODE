extends Area2D

@export var settings : LabelSettings;
@export var slow_down : bool = false;
@export var quote : String = "";

var message_show : bool = false;

func _flip_message() -> void:
	TextSpawner.new(settings).spawn(get_tree(), GlobalInfo.player.global_position + Vector2(0, -80), quote, 10);

func _on_player_enter(body: Node2D) -> void:
	if !is_zero_approx(body.rotation):
		return;
	var tw = create_tween();
	
	if slow_down:
		TimeManager.instant_time_scale(0.1, 0.8, true);
		GlobalInfo.camera.zoom_event(Vector2(0.1, 0.1), Vector2(1.2, 1.2));
	
	if !message_show:
		_flip_message();
		message_show = true;
		
	tw.tween_property(body, "rotation_degrees", 360 * sign(body.velocity.x), 0.4);
	await get_tree().create_timer(0.4).timeout;
	
	if slow_down:
		GlobalInfo.camera.zoom_event(Vector2(0.2, 0.2), Vector2(0.8, 0.8));
	body.rotation = 0;
	print(body.rotation)
