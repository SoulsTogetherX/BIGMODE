class_name Boss extends CharacterBody2D

const GRAVITY : int =  980;

var max_health : int;
var health : int;

@onready var danger_mod: Area2D = $danger_mod
@onready var sprite: Sprite2D = $Sprite2D
@onready var body: Sprite2D = $Sprite2D
@onready var shoulder: CollisionShape2D = $shoulder
@onready var floor_detect: Area2D = $floor_detect
@onready var find_ground: RayCast2D = $find_ground

func _ready() -> void:
	switch_phase(0);

func shot_at() -> void:
	health -= 1;
	if health == 0:
		die();
	else:
		var tw = create_tween();
		tw.set_trans(Tween.TRANS_SINE);
		tw.tween_property(sprite, "modulate", Color("#ff4646"), 0.05);
		tw.tween_property(sprite, "modulate", Color.WHITE, 0.05);

func die() -> void:
	queue_free();

func turn(left : bool) -> void:
	body.flip_h = left;

func get_walk_pos(max_walk : float = 1000) -> float:
	var target = GlobalInfo.player.position.x + 100 * sign(position.x - GlobalInfo.player.position.x);
	if abs(target) > 672:
		target = 672 * sign(target);
	target = clamp(target, position.x - max_walk, position.x + max_walk);
	
	return target;

func _first_pair_sort(val1 : Array, val2 : Array) -> bool:
	return val1[0] < val2[0];

func get_jump_target(to_player : bool = true) -> Marker2D:
	var jump_points : Array = get_tree().get_nodes_in_group("Jump_point");
	var distances : Array[Array] = [];
	if to_player:
		for point : Node2D in jump_points:
			distances.append([GlobalInfo.player.global_position.distance_to(point.global_position), point]);
		distances.sort_custom(_first_pair_sort);
		return distances[0][1];
	else:
		for point : Node2D in jump_points:
			if point.get_meta("mid", false):
				distances.append([global_position.distance_to(point.global_position), point]);
		distances.sort_custom(_first_pair_sort);
		return distances[randi_range(1, distances.size() - 1)][1];

func on_floor() -> bool:
	return !floor_detect.get_overlapping_bodies().is_empty();

func find_floor() -> float:
	find_ground.force_raycast_update();
	return floor(find_ground.get_collision_point().y);

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

const minon_scene : PackedScene = preload("res://src/objects/minon/minon.tscn");
func spawn_minons(spawn_falling : bool = false) -> void:
	for node_info in get_tree().get_nodes_in_group("spawner_node"):
		var minion : Minon = minon_scene.instantiate();
		get_tree().current_scene.add_child(minion);
		minion.global_position = node_info.global_position;
		
		minion.move = true;
		minion.fall_move = true;
		minion.face_left = node_info.get_meta("left", false);


#AI

enum ACTION_SELECT {ATTACK1 = 0, ATTACK2 = 1, IDLE = 2, SPAWN = 3, SPAWN_MUl = 4, WALK = 5, JUMP_PLAYER = 6, JUMP_PLAYER_ATTACK2 = 7, JUMP_RANDOM = 8, JUMP_MUL = 9, JUMP_ATTACK2 = 10, MAX = 11};
enum ACTION {ATTACK1 = 0, ATTACK2 = 1, IDLE = 2, SPAWN = 3, WALK = 4, JUMP = 5};

var prev_idx  : int = -1;
var phase     : int = 0;
var wave_jump : bool = true;

const STAGE_DELAYS : Array[Array] = [
	# Stage 1
	[
		[0.7,1.2], # ATTACK1
		[0.5,0.7], # ATTACK2
		[0.4,1.0], # IDLE
		[0,0], # SPAWN
		[0,0], # SPAWN_MUl
		[0.2,0.3], # WALK
		[0.3,0.5], # JUMP_PLAYER
		[1.0,1.3], # JUMP_PLAYER_ATTACK2
		[0.3,0.5], # JUMP_RANDOM
		[0.5,0.7], # JUMP_MUL
		[0.85,1.1], # JUMP_ATTACK2
	],
	# Stage 2
	[
		
	],
	# Stage 3
	[
		
	],
]

const STAGE_HEALHS = [100, 150, 200];
const STAGE_RANGES = [200, 300, 400];

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
			5,   # WALK
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
			6,   # WALK
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
			1,   # WALK
			26,  # JUMP_PLAYER
			15,  # JUMP_PLAYER_ATTACK2
			0,   # JUMP_RANDOM
			0,   # JUMP_MUL
			0,   # JUMP_ATTACK2
		],
	]
]

func switch_phase(switch_phase : int) -> void:
	phase = switch_phase;
	
	max_health = STAGE_HEALHS[phase];
	danger_mod.radius = STAGE_RANGES[phase];
	
	health = max_health;
	wave_jump = (phase > 0);

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
	var selected_idx : int;
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
				ret.append([ACTION.SPAWN, 0.1]);
			ret.append([ACTION.SPAWN, delay]);
		ACTION_SELECT.WALK:
			ret.append([ACTION.WALK, delay, get_walk_pos()]);
		ACTION_SELECT.JUMP_PLAYER:
			ret.append([ACTION.JUMP, delay, get_jump_target(true)]);
		ACTION_SELECT.JUMP_PLAYER_ATTACK2:
			ret.append([ACTION.JUMP, 0, get_jump_target(true)]);
			ret.append([ACTION.ATTACK2, delay]);
		ACTION_SELECT.JUMP_RANDOM:
			ret.append([ACTION.JUMP, delay, get_jump_target(false)]);
		ACTION_SELECT.JUMP_MUL:
			for i in randi_range(1,4):
				ret.append([ACTION.JUMP, 0.1, get_jump_target(false)]);
			ret.append([ACTION.JUMP, delay]);
		ACTION_SELECT.JUMP_ATTACK2:
			ret.append([ACTION.JUMP, 0, get_jump_target(false)]);
			ret.append([ACTION.ATTACK2, delay]);
	
	return ret;

func wait_after_prioirtize() -> float:
	return 0.0;
