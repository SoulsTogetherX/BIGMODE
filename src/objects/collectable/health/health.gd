extends Node2D

func _on_entered(body: Node2D) -> void:
	pass;

func _on_collect(body: Node2D) -> void:
	GlobalInfo.player_health += 1;
	queue_free();
