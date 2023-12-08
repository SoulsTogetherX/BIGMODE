extends Node

var camera : CameraFollow2D;
var player : Player;

var score : int = 0;

signal score_increased;

func increase_score(inc : int) -> void:
	score += inc;
	score_increased.emit();
