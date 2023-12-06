extends Node2D

@onready var cooldown: Timer = $Cooldown
var cool : bool = true;

@export var settings : LabelSettings;
@export var slow_down : bool = false;

var collect_quote : QuotesInfo = QuotesInfo.new();

func _ready() -> void:
	collect_quote.quotes = [
		["ZOOM!", 3],
		["GO! GO! GO!", 3],
		["COFFEE!", 3],
		["NO SLOW!", 3],
		["FASTER!", 3],
		["SPEED IS KEY!", 3],
		["DON'T DO DRUGS!", 2],
		["KEY IS SPEED!", 1],
		["LAWS MEAN NOTHING", 0.8],
		["WHAT BRAND IS THIS!?", 0.8],
		["RADIOACTIVE!?", 0.1],
		["Traffic accident waiting to happen...", 1],
		];

func _collect_message() -> void:
	TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, -30), collect_quote.pick_random(), 10);

func _player_entered(body: Node2D) -> void:
	if cool:
		_collect_message();
		cool = false;
		cooldown.start();
		
		if slow_down:
			GlobalInfo.camera.zoom_event(Vector2(0.5, 0.5), Vector2(1.5, 1.5));
			TimeManager.instant_time_scale(0.3, 0.5, true);
			await get_tree().create_timer(0.5, true, false, true).timeout;
			GlobalInfo.camera.zoom_event(Vector2(0.5, 0.5), Vector2(1, 1));
	
	body.boosted = true;

func _on_cooldown_timeout() -> void:
	cool = true;
