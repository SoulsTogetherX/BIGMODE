extends Node

var menu_fancy : bool = false;
var hard_coded_offset__I_am_a_terrible_programmer   : Vector2 = Vector2(0,0);
var hard_coded_player_velocity__I_am_a_terrible_programmer   : Vector2 = Vector2(0,0);
var hard_coded_player_y__I_am_a_terrible_programmer : float = 0;
var hard_coded_flag_check__I_am_a_terrible_programmer : bool = false;

var respawn_pos : Vector2 = Vector2.ZERO:
	set(val):
		respawn_pos = val;

var camera : CameraFollow2D;
var player : Player;

var cutscene : bool = false:
	set(val):
		if player:
			player.force_cutscene(val);
		cutscene = val;
var cutscene_before : bool = false;

var score : int = 0;
var player_health     : int = 5:
	set = update_health;
var player_max_health : int = 5:
	set = update_max_health;

var boss_room : bool = false;
var request_spawn_pos : bool = true;
var enemy_hp_inc : bool = false;

signal score_increased;
signal updated_health(old : int);
signal updated_max_health(old : int);

static var player_scene = preload("res://src/objects/player/player.tscn");
func respawn() -> void:
	await Transition.fade_in(0.5);
	
	player_health = player_max_health;
	if boss_room:
		SoundManager.stop();
		
		get_tree().reload_current_scene();
		
		await get_tree().create_timer(0.2).timeout;
		Transition.fade_out(0.5);
		return;
	
	player.queue_free();
	player = player_scene.instantiate();
	player.global_position = respawn_pos;
	get_tree().current_scene.add_child(player);
	
	camera.follow = player;
	
	await get_tree().create_timer(0.2).timeout;
	Transition.fade_out(0.5);

func reset_values() -> void:
	boss_room = false;
	hard_coded_flag_check__I_am_a_terrible_programmer = false;
	request_spawn_pos = true;
	
	score = 0;
	player_health = player_max_health;
	TimeManager.time = 0;
	TimeManager.toggle_timer(false);
	
	SoundManager.pitch_scale = 1.0;

func increase_score(inc : int) -> void:
	score += inc;
	score_increased.emit();

func update_health(val : int) -> void:
	var old : int = player_health;
	player_health = clamp(val, 0, player_max_health);
	
	updated_health.emit(old);

func update_max_health(val : int) -> void:
	var old : int = player_max_health;
	player_health = min(val, player_health);
	player_max_health = val;
	
	updated_max_health.emit(old);
