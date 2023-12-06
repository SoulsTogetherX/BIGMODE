class_name Player extends CharacterBody2D

const SPEED         : float =  500;
const BOOST_SPEED   : float =  2000;
const JUMP_VELOCITY : int   = -400;
const BOOST_JUMP    : float = -500;
const JUMP_CUTOFF   : float = -50.;
const BOOST_CUTOFF  : float = -60;
const GRAVITY       : int   =  980;

@export var settings : LabelSettings;

@onready var coyote_timer   : Timer            = $coyote_timer;
@onready var jump_buffer    : Timer            = $jump_buffer;
@onready var boost_timer    : Timer            = $boost_timer
@onready var walk_time      : Timer            = $walk_time;
@onready var body_overhead  : StateOverhead    = $body;
@onready var body_collide   : CollisionShape2D = $bodyCollide;
@onready var turn_node      : Node2D           = $turn_node;
@onready var davids_gun     : Sprite2D         = $turn_node/DavidsGun
@onready var on_wall        : Area2D           = $turn_node/on_wall

var land_quotes      : QuotesInfo = QuotesInfo.new();
var jump_quotes      : QuotesInfo = QuotesInfo.new();
var coyote_quotes    : QuotesInfo = QuotesInfo.new();
var shoot_quotes     : QuotesInfo = QuotesInfo.new();
var wall_kick_quotes : QuotesInfo = QuotesInfo.new();

var fix_speed_when_next_on_ground : bool = false;
var boosted : bool = false:
	set(val):
		if not is_inside_tree():
			await ready;
		
		boosted = val;
		if boosted:
			boost_timer.start();
			if body_overhead.is_in_states("main", ["idle", "slow_down"]):
				body_overhead.change_state("main", "move");
		else:
			boost_timer.stop();
			if body_overhead.is_in_state("main", "move"):
				body_overhead.change_state("main", "slow_down");

func _ready() -> void:
	boost_timer.timeout.connect(func(): boosted = false);
	
	land_quotes.quotes = [
		["Landed", 5],
		["Puff", 2],
		["Hit", 2],
		["Grounded", 1.5],
		["Gravity sucks", 0.4],
		["Go! Go! Go!", 2],
		["Faster!", 2],
		["Lunded", 0.8],
		["Try flying noob", 0.01]
		];
	jump_quotes.quotes = [
		["Jump", 8],
		["Boing", 6],
		["Bounce", 6],
		["Liftoff", 2.5],
		["Higher!", 2.5],
		["10/10 jump", 1.],
		["0/10 jump", 1.],
		["Jamp", 1.2],
		["[Insert insult here]", 0.3]
		];
	coyote_quotes.quotes = [
		["Jump", 5],
		["Air time", 3],
		["Whoosh", 3],
		["Whish", 3],
		["Gravity Dead", 1.5],
		["Up, not down", 1.5],
		["Late", 0.8],
		["Jamp", 1.],
		["Physics-chan go bye", 0.1]
		];
	shoot_quotes.quotes = [
		["Shoot", 5],
		["Bang", 5],
		["Bang Bang", 1],
		["Bamp", 5],
		["Zoom", 2],
		["Zeem", 2],
		["Zhoot", 0.6],
		["Bung", 0.6],
		["*Gun Noises*", 1],
		["Die Beam!", 1],
		["Shootie", 1],
		["What are you even shooting?", 0.2],
		["I'm sure that will buff out", 0.11],
		["I'm not paid enough", 0.09],
		];
	wall_kick_quotes.quotes = [
		["Jump", 6],
		["Boing", 6],
		["Bounce", 6],
		["Back Take", 3],
		["Do a flip", 3],
		["Jamp", 2.5],
		["Stunt man here", 2.5],
		["Don't hurt yourself", 2],
		["Rude", 0.8],
		["Walls do be like that", 1],
		["Boosted", 3],
		["Reversal", 2],
		["No U", 2.2],
		["Ram it with your head", 0.2],
		["Turn off", 0.2],
		];

func get_movement() -> float:
	return Input.get_axis("left", "right");

func _physics_process(delta: float) -> void:
	if boosted:
		velocity.x = sign(velocity.x) * max(BOOST_SPEED, abs(velocity.x));
	
	move_and_slide();

func turn(left : bool = false) -> void:
	var sign_c : float = (-1 if left else 1);
	
	turn_node.scale.x = sign_c;
	body_collide.position.x = 4 * sign_c;
	
func force_jump() -> void:
	body_overhead.change_state("main", "jump");

func reset_fall() -> void:
	body_overhead.change_state("main", "fall");

func is_falling() -> bool:
	return body_overhead.is_in_state("main", "fall");

func kill() -> void:
	queue_free();


func _shoot_message(pos : Vector2 = Vector2.ZERO) -> void:
	TextSpawner.new(settings).spawn(get_tree(), pos, shoot_quotes.pick_random());

func _land_message() -> void:
	TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, 30), land_quotes.pick_random());

var _69_420_counter = 0;
func _jump_message() -> void:
	_69_420_counter += 1;
	match _69_420_counter:
		69:
			TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, 30), "Shaboingboing");
		420:
			TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, 30), "420 Blazzing");
		_:
			TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, 30), jump_quotes.pick_random());
func _coyote_message() -> void:
	_69_420_counter += 1;
	match _69_420_counter:
		69:
			TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, 30), "Shaboingboing");
		420:
			TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, 30), "420 Blazzing");
		_:
			TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, 30), coyote_quotes.pick_random());

func _wall_kick_message() -> void:
	TextSpawner.new(settings).spawn(get_tree(), global_position + Vector2(0, 30), wall_kick_quotes.pick_random());


var _prev_move : float = INF;
func _move_hor(overwrite : bool = false) -> bool:
	var move : float = get_movement();
	if boosted:
		if velocity.x != 0:
			turn(velocity.x < 0);
	elif move == 0:
		_prev_move = 0;
		return false;
	else:
		turn(move < 0);
	if _prev_move == move && !overwrite:
		return true;
	
	_prev_move = move;
	if boosted:
		if move != 0:
			velocity.x = lerp(velocity.x, move * BOOST_SPEED, 0.9);
	else:
		velocity.x = lerp(velocity.x, move * SPEED, 0.9);
	
	return true;
