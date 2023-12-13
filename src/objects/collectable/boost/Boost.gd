extends Node2D

@export var settings : LabelSettings;
@export var slow_down : bool = false;
@export var slow_down_time : float = 0.5;
@export var slow_down_ratio : float = 0.3;

var collect_quote : QuotesInfo = QuotesInfo.new();

@export var message : String = "";

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
	if message != "":
		TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, -30), message, 10);
		message = "";
		return;
	
	TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, -30), collect_quote.pick_random(), 10);

func _on_collect(body: Node2D) -> void:
	_collect_message();
	if slow_down:
		GlobalInfo.camera.zoom_event(Vector2(0.1, 0.1), Vector2(1.1, 1.1));
		TimeManager.instant_time_scale(slow_down_ratio, slow_down_time, true);
		await get_tree().create_timer(slow_down_time, true, false, true).timeout;
		GlobalInfo.camera.zoom_event(Vector2(0.1, 0.1), Vector2(0.8, 0.8));

func _on_entered(body: Node2D) -> void:
	body.boosted = true;
