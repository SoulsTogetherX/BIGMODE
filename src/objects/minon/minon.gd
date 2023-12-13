@tool
class_name Minon extends CharacterBody2D

const GRAVITY : int   =  980;
var move_speed : float = 250.;
var hp = 1;

@export var settings  : LabelSettings;
@export var move      : bool = false:
	set(val):
		if not is_inside_tree():
			await ready;
		elif val:
			$StateOverhead.change_state("main", "walk");
		
		move = val;

@export var fall_move : bool = false;
@export var face_left : bool:
	set(val):
		if not is_inside_tree():
			await ready;
		
		var sign_c = (1 if val else -1);
		body.scale.x = sign_c;
		forward_detect.target_position.x = 1.25 * sign_c;
		face_left = val;

@onready var weak_point: Area2D = $weak_point;
@onready var body: Sprite2D = $body
@onready var fall_detect: RayCast2D = $body/fall_detect
@onready var forward_detect: RayCast2D = $body/forward_detect
@onready var death_sound: Emitter = $death_sound
@onready var explode_sound: Emitter = $death

var crushed_quotes : QuotesInfo = QuotesInfo.new();
var shot_quotes    : QuotesInfo = QuotesInfo.new();
var spike_quotes   : QuotesInfo = QuotesInfo.new();
var blast_quotes   : QuotesInfo = QuotesInfo.new();

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
		["But I never got to--!", 0.14],
		["Are you even licenced for that?", 0.12],
		["I was the janitor!", 0.1],
		["Pineapple Pizza is--", 0.05],
		];
	
	spike_quotes.quotes = [
		["Argh", 2],
		["Ow", 2],
		["Painful", 2],
		["Cruel World", 2],
		["Pointy", 1.6],
		["Please contact IT", 1.4],
		["ERROR", 1.4],
		["Safety hazard.", 1.4],
		["Sharp", 1],
		["Owowowowow", 0.6],
		["Puinty", 0.6],
		["Medic!", 0.3],
		["Shurp", 0.2],
		["*Sounds of Impalement*", 0.3],
		["Who placed these here?", 0.3],
		["I see the light!", 0.2],
		["Metal should be friendly!", 0.14],
		["What a way to go...", 0.1],
		[":D", 0.1],
		["I still think pineapple Pizza is--", 0.05],
		];
	
	blast_quotes.quotes = [
		["Argh", 2],
		["Ow", 2],
		["Painful", 2],
		["Cruel World", 2],
		["Pointy", 1.6],
		["Friendly Fire", 1.4],
		["ERROR", 1.4],
		["Why did you make me?", 1.4],
		["Sizzel", 1.4],
		["Target not reached!", 1.0],
		["Flashy", 0.6],
		["BIG GUY!", 0.3],
		["Puinful!", 0.3],
		["#@%@#^$^", 0.2],
		["*Sounds of generic death*", 0.3],
		["What was my purpose?", 0.3],
		["Metal should be friendly!", 0.14],
		["What a way to go...", 0.1],
		["D:", 0.1],
		["I still think pineapple Pizza is--", 0.05],
		];
	
	
	fall_detect.add_exception(self);
	forward_detect.add_exception(self);
	
	if Engine.is_editor_hint():
		set_process(false);
		set_physics_process(false);
	elif GlobalInfo.enemy_hp_inc:
		hp = 2;

func _jumped_on(body: Node2D) -> void:
	if $StateOverhead.is_in_state("main", "ded"):
		return;
	
	body.force_jump();
	body.velocity.x *= 1.3;
	
	hp -= 1;
	if hp > 0:
		hurt_animate();
		return;
	
	TextSpawner.new(settings).spawn(get_tree(), global_position, crushed_quotes.pick_random());
	kill();

func shot_at() -> void:
	hp -= 1;
	if hp > 0:
		hurt_animate();
		return;
	
	TextSpawner.new(settings).spawn(get_tree(), global_position, shot_quotes.pick_random());
	kill();

func crashed_into() -> void:
	hp -= 1;
	if hp > 0:
		hurt_animate();
		return;
	
	kill();

func _kill_player(body: Node2D) -> void:
	if $StateOverhead.is_in_state("main", "ded") || body.boosted:
		return;
	
	body.kill();
	
	hp -= 1;
	if hp > 0:
		hurt_animate();
		return;
	
	crashed_into();

func spike_kill() -> void:
	TextSpawner.new(settings).spawn(get_tree(), global_position, spike_quotes.pick_random());
	kill();

func blast_kill() -> void:
	TextSpawner.new(settings).spawn(get_tree(), global_position, blast_quotes.pick_random());
	kill();

func hurt_animate() -> void:
	var tw = create_tween();
	tw.set_trans(Tween.TRANS_SINE);
	tw.tween_property(body, "modulate", Color("#ff4646"), 0.05);
	tw.tween_property(body, "modulate", Color.WHITE, 0.05);

func kill() -> void:
	if $StateOverhead.is_in_state("main", "ded"):
		return;
	collision_layer = 0;
	$StateOverhead.change_state("main", "ded");
	
	explode_sound.play_random();
	explode_sound.pitch_scale = (randf() * 0.1) + 0.95;
	if randf() <= 0.1:
		death_sound.play_random();

func turn():
	$StateOverhead/main/move.turn();
