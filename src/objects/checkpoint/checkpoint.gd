extends Node2D

@export var turn : bool = false:
	set(val):
		turn = val;
		$Sprite2D.flip_h = turn;

var checked : bool = false;

func _ready() -> void:
	if GlobalInfo.hard_coded_flag_check__I_am_a_terrible_programmer:
		GlobalInfo.player.global_position = global_position;

func _on_player_entered(_body: Node2D) -> void:
	if checked:
		return;
	
	checked = true;
	if GlobalInfo.respawn_pos == global_position:
		$Sprite2D.frame = 6;
		return;
	
	$AnimationPlayer.play("checked");
	GlobalInfo.respawn_pos = global_position;
