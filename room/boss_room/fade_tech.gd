extends Area2D

func _process(delta: float) -> void:
	var diff : float = (global_position.x - GlobalInfo.player.global_position.x);
	modulate.a = 1.0 - ((diff + 950) / -1350);

func _on_player_entered(_body: Node2D) -> void:
	set_process(true);

func _on_player_exited(_body: Node2D) -> void:
	modulate.a = 0.0;
	set_process(false);
