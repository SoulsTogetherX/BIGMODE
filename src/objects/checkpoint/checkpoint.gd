extends Node2D

@export var turn : bool = false:
	set(val):
		turn = val;
		$Sprite2D.flip_h = turn;

var checked : bool = false;

func _on_player_entered(_body: Node2D) -> void:
	if checked:
		return;
	
	checked = true;
	$AnimationPlayer.play("checked");
	GlobalInfo.respawn_pos = global_position;
