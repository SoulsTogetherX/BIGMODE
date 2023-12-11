@tool
extends Node2D

@export var turn : bool = false:
	set(val):
		turn = val;
		$orb.flip_h = turn;

func _ready() -> void:
	$orb.frame = randi_range(4, 7);

func _on_collect(body : Node2D):
	GlobalInfo.increase_score(100);
	
func _on_entered(body):
	visible = false;
	$Collect/CollisionShape2D.disabled = true;
	
	$collect.play();
	await $collect.finished;
	queue_free();
