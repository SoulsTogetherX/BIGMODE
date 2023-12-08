extends Area2D

@onready var cooldown: Timer = $Timer;
var cool : bool = true;

@export var cooldown_time : float = 0.1;
@export var _actor : Node2D;

func _ready() -> void:
	cooldown.wait_time = cooldown_time;

func _player_entered(body: Node2D) -> void:
	if cool:
		cool = false;
		cooldown.start();
		_actor._on_collect(body);
	_actor._on_entered(body);

func _on_cooldown_timeout() -> void:
	cool = true;
