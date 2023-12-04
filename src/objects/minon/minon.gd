@tool
extends CharacterBody2D

const GRAVITY : int   =  980;
var move_speed : float = 250.;

@export var settings  : LabelSettings;
@export var move      : bool = false:
	set(val):
		if not is_inside_tree():
			await ready;
		
		move = val;
		if move:
			$StateOverhead/x_pos.process_mode = Node.PROCESS_MODE_INHERIT;
		else:
			$StateOverhead/x_pos.process_mode = Node.PROCESS_MODE_DISABLED;

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
		["Please contact IT", 1],
		["Mission failed", 1],
		["Invaild thread count", 0.6],
		["Error 404 life not found", 0.6],
		["Processes failing", 0.5],
		["0x596F7572204D6F6D", 0.2],
		["I had a family!", 0.1]
		];
	
	if Engine.is_editor_hint():
		set_process(false);
		set_physics_process(false);

func _jumped_on(body: Node2D) -> void:
	body.display = false;
	body.force_jump();
	kill();

func _kill_player(body: Node2D) -> void:
	body.kill();

func kill() -> void:
	TextSpawner.new(settings).spawn(get_tree(), global_position, quotes.pick_random());
	queue_free();

func turn(left : bool = false) -> void:
	var sign_c = (1 if left else -1);
	
	fall_detect.position.x = 27 * sign_c;
	forward_detect.position.x = fall_detect.position.x;
	forward_detect.target_position.x = sign_c * 2;
	
	body.flip_h = left;
	_face_left = left;
