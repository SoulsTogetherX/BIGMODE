@tool
class_name Minon extends CharacterBody2D

const GRAVITY : int   =  980;
var move_speed : float = 250.;

@export var settings  : LabelSettings;
@export var move      : bool = false:
	set(val):
		if not is_inside_tree():
			await ready;
		
		move = val;

@export var fall_move : bool = false;
@export var face_left : bool:
	set(val):
		if not is_inside_tree():
			await ready;
		
		body.scale.x = (1 if val else -1);
		face_left = val;

@onready var weak_point: Area2D = $weak_point;
@onready var body: Sprite2D = $body
@onready var fall_detect: RayCast2D = $body/fall_detect
@onready var forward_detect: RayCast2D = $body/forward_detect

var crushed_quotes : QuotesInfo = QuotesInfo.new();
var shot_quotes    : QuotesInfo = QuotesInfo.new();

func _ready() -> void:
	crushed_quotes.quotes = [
		["Ow", 2],
		["Painful", 2],
		["Memory Damage", 2],
		["Segfault", 2],
		["Kill Switch", 2],
		["Critical Falure", 1],
		["Please contact IT", 1],
		["Mission failed", 1],
		["Invaild thread count", 0.7],
		["Error 404 life not found", 0.7],
		["Processes failing", 0.65],
		["Fatty", 0.6],
		["Robot will remember", 0.2],
		["You will regret this!", 0.1],
		["0x596F7572204D6F6D", 0.2],
		["100 0 01 100", 0.2],
		["I had a family!", 0.1],
		["Pineapple Pizza is--", 0.05],
		];
	
	shot_quotes.quotes = [
		["Argh", 2],
		["Ow", 2],
		["Painful", 2],
		["Memory Damage", 2],
		["Lunitic", 1.6],
		["Please contact IT", 1.4],
		["ERROR", 1.4],
		["Security Alert", 1],
		["Rude much?", 0.6],
		["I will not d--!", 0.3],
		["Hardware bypassed", 0.3],
		["*Brutal death noises*", 0.3],
		["Paycheck deductions", 0.2],
		["Who gave you a gun?", 0.2],
		["Are you even licenced for that?", 0.12],
		["I was the janitor!", 0.1],
		["Pineapple Pizza is--", 0.05],
		];
	
	fall_detect.add_exception(self);
	forward_detect.add_exception(self);
	
	if Engine.is_editor_hint():
		set_process(false);
		set_physics_process(false);

func _jumped_on(body: Node2D) -> void:
	body.force_jump();
	body.velocity.x *= 1.3;
	TextSpawner.new(settings).spawn(get_tree(), global_position, crushed_quotes.pick_random());
	kill();

func shot_at() -> void:
	TextSpawner.new(settings).spawn(get_tree(), global_position, shot_quotes.pick_random());
	kill();

func _kill_player(body: Node2D) -> void:
	if $StateOverhead.is_in_state("main", "ded") || body.boosted:
		return;
	body.kill();

func kill() -> void:
	if $StateOverhead.is_in_state("main", "ded"):
		return;
	collision_layer = 0;
	$StateOverhead.change_state("main", "ded");
