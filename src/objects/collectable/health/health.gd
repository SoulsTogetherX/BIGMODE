extends Node2D

@export var settings : LabelSettings;
var collect_quote : QuotesInfo = QuotesInfo.new();

func _ready() -> void:
	collect_quote.quotes = [
		["Yummy!", 3],
		["Delicious", 3],
		["Gourmet Stuff!", 3],
		["#No copyright", 3],
		["Fatty.", 3],
		["Eat more, think less!", 3],
		["Heal, Heal, Heal", 2],
		["Ymmu", 1],
		["Who placed this here?", 0.2],
		["Enjoy", 1],
		["5 second rule!", 2],
		[":DDDD", 0.8],
		];

func _on_collect(body: Node2D) -> void:
	GlobalInfo.increase_score(500);
	
	GlobalInfo.player_health += 1;
	visible = false;
	$Collect.queue_free();
	
	TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, -30), collect_quote.pick_random(), 10);
	
	$sound.play();
	await $sound.finished;
	queue_free();

func _on_entered(body: Node2D) -> void:
	pass;
