class_name Boss extends CharacterBody2D

const GRAVITY : int =  980;

var max_health : int;
var health : int;

@onready var state_overhead: StateOverhead = $StateOverhead
@onready var body: Sprite2D = $Sprite2D;
@onready var shoulder: CollisionShape2D = $shoulder;
@onready var danger_mod: Area2D = $danger_mod;
@onready var ground_punch: Area2D = $Sprite2D/ground_punch;
@onready var floor_detect: Area2D = $floor_detect;
@onready var find_ground: RayCast2D = $find_ground;
@onready var blast_particles : Array[CPUParticles2D] = [$Sprite2D/BlastParticle_1, $Sprite2D/BlastParticle_2, $Sprite2D/BlastParticle_3];
@onready var intro: Emitter = $Intro;
@onready var smoke_particle: ParticleClear = $Sprite2D/SmokeParticle

@export var floor_mid_marker : Marker2D;
@export var warning : Node2D;
@export var light_manager : Node2D;
@export var activate_area : Area2D;

var health_bar : TextureProgressBar;

func _ready() -> void:
	switch_phase(0);

func shot_at() -> void:
	if GlobalInfo.cutscene || stage_lock:
		return;
	
	health -= 1;
	health_bar.value = health;
	if health == 0:
		if phase == 2:
			die();
			return;
		switch_phase(phase + 1);
	elif phase == 2 && health < 70:
		smoke_particle.emitting = true;
	
	
	hurt_animate()

func hurt_animate() -> void:
	var tw = create_tween();
	tw.set_trans(Tween.TRANS_SINE);
	tw.tween_property(body, "modulate", Color("#ff4646"), 0.05);
	tw.tween_property(body, "modulate", Color.WHITE, 0.05);

func die() -> void:
	create_tween().tween_property(health_bar, "modulate:a", 0.0, 1.0);
	
	for clean in get_tree().get_nodes_in_group("Cleanable"):
		if clean is Minon:
			clean.kill();
		else:
			clean.end_animate()
	
	state_overhead.change_state("main", "ded_fall");
	$StateOverhead/StateMachine/transition.cutscene_3 = true;

func turn(left : bool) -> void:
	var change : int = (-1 if left else 1);
	
	body.scale.x = change;

func get_walk_pos(max_walk : float = 1000) -> float:
	var target = GlobalInfo.player.position.x + 100 * sign(position.x - GlobalInfo.player.position.x);
	if abs(target) > 672:
		target = 672 * sign(target);
	target = clamp(target, position.x - max_walk, position.x + max_walk);
	
	return target;

func _first_pair_sort(val1 : Array, val2 : Array) -> bool:
	return val1[0] < val2[0];

func get_jump_target(to_player : bool = true) -> Marker2D:
	var distances : Array[Array] = [];
	if to_player:
		for point : Node2D in get_tree().get_nodes_in_group("Jump_point"):
			if phase > 0 && point.get_meta("floor", false):
				continue;
			
			distances.append([GlobalInfo.player.global_position.distance_squared_to(point.global_position), point]);
		distances.sort_custom(_first_pair_sort);
		return distances[0][1];
	else:
		for point : Node2D in get_tree().get_nodes_in_group("Jump_point"):
			if phase > 0 && point.get_meta("ground", false):
				continue;
			
			if point.get_meta("mid", false):
				distances.append([global_position.distance_squared_to(point.global_position), point]);
		distances.sort_custom(_first_pair_sort);
		return distances[randi_range(1, distances.size() - 1)][1];

func on_floor() -> bool:
	return !floor_detect.get_overlapping_bodies().is_empty();

func find_floor() -> float:
	find_ground.force_raycast_update();
	return floor(find_ground.get_collision_point().y);

func cam_shake() -> void:
	if spike_attack:
		GlobalInfo.camera.shake_event(Vector3(0.2, 0.2, 0), Vector3(2.5, 2.5, 0), Vector3(0.3, 0.3, 0), 0);

func blast_particle() -> void:
	blast_particles[phase].emitting = true;

const shock_scene : PackedScene = preload("res://src/objects/orange_boss/shockwave/shockwave.tscn");
func create_shockwave() -> void:
	var shock : Node2D = shock_scene.instantiate();
	shock.global_position = global_position;
	get_tree().current_scene.add_child(shock);
	shock.init(300, false);
	
	shock = shock_scene.instantiate();
	shock.global_position = global_position;
	get_tree().current_scene.add_child(shock);
	shock.init(300, true);

var activated_spikes : Array[Marker2D] = [];
func activate_spikes() -> void:
	for player in ground_punch.get_overlapping_bodies():
		player.kill();
	
	if !wave_jump:
		create_shockwave();
	if !spike_attack:
		return;
	
	var distances : Array[Array] = [];
	for point : Node2D in get_tree().get_nodes_in_group("Jump_point"):
		if phase > 0 && point.get_meta("floor", false):
			continue;
		if !point.get_meta("mid", true):
			continue;
		if abs(point.global_position.y - global_position.y) > 50:
			continue;
		
		distances.append([abs(global_position - point.global_position), point]);
	distances.sort_custom(_first_pair_sort);
	
	var spike = distances.front()[1];
	if spike.activated:
		return;
	
	spike.activate_spikes(global_position.x);
	if spike != floor_mid_marker:
		activated_spikes.append(spike);
	
	if activated_spikes.size() > phase:
		activated_spikes.front().retract_spikes();
		activated_spikes.pop_front();


const minon_scene : PackedScene = preload("res://src/objects/minon/minon.tscn");
func spawn_minons(_spawn_falling : bool = false) -> void:
	for node_info in get_tree().get_nodes_in_group("spawner_node"):
		var minion : Minon = minon_scene.instantiate();
		get_tree().current_scene.add_child(minion);
		minion.global_position = node_info.global_position;
		
		minion.move = true;
		minion.fall_move = true;
		minion.face_left = node_info.get_meta("left", false);
		
		minion.spawn_health = true;
		
		minion.add_to_group("Cleanable");

func play_intro() -> void:
	GlobalInfo.hard_coded_player_velocity__I_am_a_terrible_programmer = Vector2.ZERO;
	intro.play_random();

#AI

enum ACTION_SELECT {ATTACK1 = 0, ATTACK2 = 1, IDLE = 2, SPAWN = 3, SPAWN_MUl = 4, WALK = 5, JUMP_PLAYER = 6, JUMP_PLAYER_ATTACK2 = 7, JUMP_RANDOM = 8, JUMP_MUL = 9, JUMP_ATTACK2 = 10, MAX = 11};
enum ACTION {ATTACK1 = 0, ATTACK2 = 1, IDLE = 2, SPAWN = 3, WALK = 4, JUMP = 5};

var prev_idx     : int = -1;
var phase        : int = 0;
var wave_jump    : bool = false;
var spike_attack : bool = false;

const STAGE_DELAYS : Array[Array] = [
	# Stage 1
	[
		[0.7,1.2], # ATTACK1
		[0.5,0.7], # ATTACK2
		[0.4,1.0], # IDLE
		[0.1,0.1], # SPAWN
		[0.1,0.1], # SPAWN_MUl
		[0.2,0.3], # WALK
		[0.3,0.5], # JUMP_PLAYER
		[1.0,1.3], # JUMP_PLAYER_ATTACK2
		[0.3,0.5], # JUMP_RANDOM
		[0.5,0.7], # JUMP_MUL
		[0.85,1.1], # JUMP_ATTACK2
	],
	
	
	# Stage 2
	[
		[0.7,1.2], # ATTACK1
		[0.5,0.7], # ATTACK2
		[0.4,1.0], # IDLE
		[0.1,0.1], # SPAWN
		[0.1,0.1], # SPAWN_MUl
		[0.2,0.3], # WALK
		[0.3,0.5], # JUMP_PLAYER
		[1.0,1.3], # JUMP_PLAYER_ATTACK2
		[0.3,0.5], # JUMP_RANDOM
		[0.5,0.7], # JUMP_MUL
		[0.85,1.1], # JUMP_ATTACK2
	],
	
	
	# Stage 3
	[
		[0.7,1.2], # ATTACK1
		[0.5,0.7], # ATTACK2
		[0.4,1.0], # IDLE
		[0.1,0.1], # SPAWN
		[0.1,0.1], # SPAWN_MUl
		[0.2,0.3], # WALK
		[0.3,0.5], # JUMP_PLAYER
		[1.0,1.3], # JUMP_PLAYER_ATTACK2
		[0.3,0.5], # JUMP_RANDOM
		[0.5,0.7], # JUMP_MUL
		[0.85,1.1], # JUMP_ATTACK2
	],
]

const STAGE_HEALHS : Array[int]   = [125, 160, 170];
const STAGE_COLORS : Array[Color] = [Color.SEA_GREEN, Color.DARK_ORANGE, Color.RED];
const STAGE_RANGES : Array[int]   = [150, 200, 300];

const VERY_SHORT_RANGE : float = 110.0;
const SHORT_RANGE : float = 300.0;
const MID_RANGE   : float = 705.0;
#const LONG_RANGE : float = INF;

const PLATFORM_HEIGHT_EST : float = 120;

const priorities = [
		# Stage 1
	[
		# Very short
		[
			8,   # ATTACK1
			8,   # ATTACK2
			4,   # IDLE
			0,   # SPAWN
			0,   # SPAWN_MUl
			0,   # WALK
			0,   # JUMP_PLAYER
			0,   # JUMP_PLAYER_ATTACK2
			1,   # JUMP_RANDOM
			0,   # JUMP_MUL
			1,   # JUMP_ATTACK2
		],
		# Short
		[
			8,   # ATTACK1
			2,   # ATTACK2
			3,   # IDLE
			0,   # SPAWN
			0,   # SPAWN_MUl
			8,   # WALK
			0,   # JUMP_PLAYER
			0,   # JUMP_PLAYER_ATTACK2
			1,   # JUMP_RANDOM
			0,   # JUMP_MUL
			1,   # JUMP_ATTACK2
		],
		# Mid
		[
			1,  # ATTACK1
			10,  # ATTACK2
			8,   # IDLE
			0,   # SPAWN
			0,   # SPAWN_MUl
			12,  # WALK
			18,  # JUMP_PLAYER
			7,   # JUMP_PLAYER_ATTACK2
			0,   # JUMP_RANDOM
			0,   # JUMP_MUL
			0,   # JUMP_ATTACK2
		],
		# Long
		[
			2,   # ATTACK1
			2,   # ATTACK2
			14,  # IDLE
			0,   # SPAWN
			0,   # SPAWN_MUl
			3,   # WALK
			26,  # JUMP_PLAYER
			15,  # JUMP_PLAYER_ATTACK2
			0,   # JUMP_RANDOM
			0,   # JUMP_MUL
			0,   # JUMP_ATTACK2
		],
	],
	
	
		# Stage 2
	[
		# Very short
		[
			10,  # ATTACK1
			2,   # ATTACK2
			2,   # IDLE
			5,   # SPAWN
			0,   # SPAWN_MUl
			0,   # WALK
			0,   # JUMP_PLAYER
			0,   # JUMP_PLAYER_ATTACK2
			1,   # JUMP_RANDOM
			0,   # JUMP_MUL
			2,   # JUMP_ATTACK2
		],
		# Short
		[
			8,   # ATTACK1
			2,   # ATTACK2
			2,   # IDLE
			7,   # SPAWN
			0,   # SPAWN_MUl
			5,   # WALK
			0,   # JUMP_PLAYER
			0,   # JUMP_PLAYER_ATTACK2
			1,   # JUMP_RANDOM
			0,   # JUMP_MUL
			2,   # JUMP_ATTACK2
		],
		# Mid
		[
			1,  # ATTACK1
			2,  # ATTACK2
			5,   # IDLE
			15,  # SPAWN
			0,   # SPAWN_MUl
			3,   # WALK
			10,  # JUMP_PLAYER
			10,  # JUMP_PLAYER_ATTACK2
			0,   # JUMP_RANDOM
			8,   # JUMP_MUL
			3,   # JUMP_ATTACK2
		],
		# Long
		[
			2,   # ATTACK1
			2,   # ATTACK2
			5,   # IDLE
			18,  # SPAWN
			1,   # SPAWN_MUl
			1,   # WALK
			17,  # JUMP_PLAYER
			20,  # JUMP_PLAYER_ATTACK2
			0,   # JUMP_RANDOM
			10,  # JUMP_MUL
			10,  # JUMP_ATTACK2
		],
	],
	
	
		# Stage 3
	[
		# Very short
		[
			30,  # ATTACK1
			13,  # ATTACK2
			0,   # IDLE
			15,  # SPAWN
			15,  # SPAWN_MUl
			0,   # WALK
			5,  # JUMP_PLAYER
			2,   # JUMP_PLAYER_ATTACK2
			1,   # JUMP_RANDOM
			0,   # JUMP_MUL
			2,   # JUMP_ATTACK2
		],
		# Short
		[
			30,  # ATTACK1
			2,   # ATTACK2
			0,   # IDLE
			15,  # SPAWN
			15,  # SPAWN_MUl
			2,   # WALK
			6,  # JUMP_PLAYER
			2,   # JUMP_PLAYER_ATTACK2
			1,   # JUMP_RANDOM
			0,   # JUMP_MUL
			2,   # JUMP_ATTACK2
		],
		# Mid
		[
			20, # ATTACK1
			1,  # ATTACK2
			0,   # IDLE
			18,  # SPAWN
			18,  # SPAWN_MUl
			2,   # WALK
			16,  # JUMP_PLAYER
			20,  # JUMP_PLAYER_ATTACK2
			0,   # JUMP_RANDOM
			0,   # JUMP_MUL
			14,  # JUMP_ATTACK2
		],
		# Long
		[
			0,   # ATTACK1
			0,   # ATTACK2
			0,   # IDLE
			18,  # SPAWN
			18,  # SPAWN_MUl
			0,   # WALK
			16,  # JUMP_PLAYER
			20,  # JUMP_PLAYER_ATTACK2
			0,   # JUMP_RANDOM
			0,   # JUMP_MUL
			18,  # JUMP_ATTACK2
		],
	],
]

var stage_lock : bool = false;
func switch_phase(s_phase : int) -> void:
	$StateOverhead/StateMachine/transition/Timer.stop();
	stage_lock = true;
	
	phase = s_phase;
	
	max_health = STAGE_HEALHS[phase];
	if GlobalInfo.enemy_hp_inc:
		max_health = floori(max_health * 1.2);
	danger_mod.radius = STAGE_RANGES[phase];
	
	health = max_health;
	wave_jump = (phase > 0);
	spike_attack = (phase > 0);
	
	if phase == 1:
		$StateOverhead/StateMachine/transition.cutscene_2 = true;
	elif phase == 2:
		light_manager.run_lights();
	
	SoundManager.pitch_scale = 1.0 + (0.01 * phase);
	
	if health_bar:
		GlobalInfo.camera.shake_event(Vector3(0.5, 0.5, 0.0), Vector3(5., 5., 0), Vector3.ZERO);
		
		var tw = create_tween().set_parallel();
		tw.tween_property(health_bar, "max_value", max_health, 0.8).set_delay(0.5);
		tw.tween_property(health_bar, "value", health, 0.8).set_delay(0.5);
		tw.tween_property(health_bar, "tint_progress", STAGE_COLORS[phase], 0.8).set_delay(0.5);
		tw.tween_property(health_bar, "rotation_degrees", -2, 0.1).set_delay(0.40);
		tw.tween_property(health_bar, "rotation_degrees", 1, 0.1).set_delay(0.55);
		tw.tween_property(health_bar, "rotation_degrees", 0, 0.1).set_delay(0.70);
		
		await tw.finished;
		
		$StateOverhead/StateMachine/transition/Timer.start();
	else:
		health_bar = $"../Camera2D/GUI".get_health_bar();
		health_bar.max_value = max_health;
		health_bar.value = health;
		health_bar.tint_progress = STAGE_COLORS[phase];
	
	stage_lock = false;

var old : int = -1;
func prioirtize() -> Array[Array]:
	var ret : Array[Array] = [];
	
	var player_distance : float = global_position.distance_to(GlobalInfo.player.global_position);
	var player_y_delta  : float = global_position.y - GlobalInfo.player.global_position.y;
			
	var is_in_same_layer : bool = (0 <= player_y_delta && player_y_delta <= PLATFORM_HEIGHT_EST);
	
	var distance_indx : int;
	if player_distance <= VERY_SHORT_RANGE:
		distance_indx = 0;
	elif player_distance <= SHORT_RANGE:
		distance_indx = 1;
	elif player_distance <= MID_RANGE:
		distance_indx = 2;
	else:
		distance_indx = 3;
	
	var unweighted : Array[float] = [];
	var weighted   : Array[float] = [];
	var sum : float = 0;
	
	for weight : float in priorities[phase][distance_indx]:
		unweighted.append(weight);
	if prev_idx != -1:
		unweighted[prev_idx] = 0.0;
		
		if prev_idx >= ACTION_SELECT.JUMP_PLAYER:
			for i in range(prev_idx, ACTION_SELECT.MAX):
				unweighted[i] = max(0, unweighted[i] - 0.2);
	if !is_in_same_layer:
		unweighted[ACTION_SELECT.WALK] -= 0.2;
		unweighted[ACTION_SELECT.ATTACK1] -= 0.2;
		if player_y_delta < 0:
			unweighted[ACTION_SELECT.WALK] -= 0.2;
	
	for weight : float in unweighted:
		sum += weight;
	for weight : float in unweighted:
		weighted.append(weight / sum);
	
	var random : float = randf();
	var selected_idx : int = 0;
	for weight in weighted:
		if random <= weight:
			break;
		random -= weight;
		selected_idx += 1;
	if selected_idx == weighted.size():
		selected_idx -= 1;
	prev_idx = selected_idx;
	
	var delays = STAGE_DELAYS[phase][selected_idx];
	var delay = randf_range(delays[0],delays[1]);
	match selected_idx:
		ACTION_SELECT.ATTACK1:
			ret.append([ACTION.ATTACK1, delay]);
		ACTION_SELECT.ATTACK2:
			ret.append([ACTION.ATTACK2, delay]);
		ACTION_SELECT.IDLE:
			ret.append([ACTION.IDLE, delay]);
		ACTION_SELECT.SPAWN:
			ret.append([ACTION.SPAWN, delay]);
		ACTION_SELECT.SPAWN_MUl:
			for i in randi_range(1,4):
				ret.append([ACTION.SPAWN, 0.15]);
			ret.append([ACTION.SPAWN, delay]);
		ACTION_SELECT.WALK:
			ret.append([ACTION.WALK, delay, get_walk_pos()]);
		ACTION_SELECT.JUMP_PLAYER:
			ret.append([ACTION.JUMP, delay, get_jump_target(true)]);
		ACTION_SELECT.JUMP_PLAYER_ATTACK2:
			ret.append([ACTION.JUMP, 0.0, get_jump_target(true)]);
			ret.append([ACTION.ATTACK2, delay]);
		ACTION_SELECT.JUMP_RANDOM:
			ret.append([ACTION.JUMP, delay, get_jump_target(false)]);
		ACTION_SELECT.JUMP_MUL:
			for i in randi_range(1,4):
				ret.append([ACTION.JUMP, 0.0, get_jump_target(false)]);
			ret.append([ACTION.JUMP, delay, get_jump_target(false)]);
		ACTION_SELECT.JUMP_ATTACK2:
			ret.append([ACTION.JUMP, 0, get_jump_target(false)]);
			ret.append([ACTION.ATTACK2, delay]);
	
	return ret;

func wait_after_prioirtize() -> float:
	return 0.0;
