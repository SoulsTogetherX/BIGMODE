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
var _face_left : bool = false;
@export var face_left : bool:
	get:
		return _face_left;
	set(val):
		if not is_inside_tree():
			await ready;
		
		turn(val);
		_face_left = val;

@onready var weak_point: Area2D = $weak_point;
@onready var body: Sprite2D = $body
@onready var fall_detect: RayCast2D = $fall_detect
@onready var forward_detect: RayCast2D = $forward_detect;

var quotes : QuotesInfo;

func _ready() -> void:
	quotes = QuotesInfo.new();
	quotes.quotes = [
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
		["I hate you!", 0.5],
		["Robot will remember", 0.2],
		["You will regret this!", 0.1],
		["0x596F7572204D6F6D", 0.2],
		["100 0 01 100", 0.2],
		["I had a family!", 0.1],
		["Pineapple Pizza is--", 0.05],
		];
	
	if Engine.is_editor_hint():
		set_process(false);
		set_physics_process(false);

func _jumped_on(body: Node2D) -> void:
	body.force_jump();
	body.velocity.x *= 1.3;
	kill();

func _kill_player(body: Node2D) -> void:
	body.kill();

func kill() -> void:
	if $StateOverhead.is_in_state("main", "ded"):
		return;
	
	TextSpawner.new(settings).spawn(get_tree(), global_position, quotes.pick_random());
	$StateOverhead.change_state("main", "ded");

func turn(left : bool = false) -> void:
	var sign_c = (1 if left else -1);
	
	fall_detect.position.x = 27 * sign_c;
	forward_detect.position.x = fall_detect.position.x;
	forward_detect.target_position.x = sign_c * 2;
	
	body.scale.x = sign_c;
