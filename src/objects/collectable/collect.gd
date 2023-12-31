extends Area2D

@onready var cooldown: Timer = $Timer;
var cool : bool = true;

@export var cooldown_time : float = 0.1;
@export var _actor : Node2D;

func _ready() -> void:
	var tw = create_tween().set_loops().set_parallel();
	_actor.position += Vector2.UP * 3;
	_actor.rotation_degrees += 10;
	
	var delay = 0.95 + randf() * 0.1;
	tw.set_trans(Tween.TRANS_QUART);
	tw.tween_property(_actor, "position", _actor.position + Vector2.DOWN * 6, delay);
	tw.tween_property(_actor, "position", _actor.position, 0.95 + randf() * 0.1).set_delay(delay);
	
	delay = 0.95 + randf() * 0.1;
	tw.set_trans(Tween.TRANS_LINEAR);
	tw.tween_property(_actor, "rotation_degrees", _actor.rotation_degrees - 20, delay);
	tw.tween_property(_actor, "rotation_degrees", _actor.rotation_degrees, 0.95 + randf() * 0.1).set_delay(delay);
	
	cooldown.wait_time = cooldown_time;

func _player_entered(body: Node2D) -> void:
	if cool:
		cool = false;
		cooldown.start();
		_actor._on_collect(body);
	_actor._on_entered(body);

func _on_cooldown_timeout() -> void:
	cool = true;
