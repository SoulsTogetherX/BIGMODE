extends Node

var camera : CameraFollow2D;
var player : Player;

var cutscene : bool = false:
	set(val):
		if player:
			player.force_cutscene(val);
		cutscene = val;
var cutscene_before : bool = false;


var score : int = 0;
var player_health     : int = 1:
	set = update_health;
var player_max_health : int = 1:
	set = update_max_health;

signal score_increased;
signal updated_health(old : int);
signal updated_max_health(old : int);

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
